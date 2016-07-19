#!/bin/bash
set -e
set -x

# postgres settings
sed -i -e"s/^shared_buffers = 128MB.*$/shared_buffers = 512MB/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#work_mem = 4MB.*$/work_mem = 1GB/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#maintenance_work_mem = 64MB.*$/maintenance_work_mem = 1GB/" ${PGDATA}/postgresql.conf
sed -i -e"s/^#checkpoint_segments = 3.*$/checkpoint_segments = 20/" ${PGDATA}/postgresql.conf

export PGUSER="$POSTGRES_USER"

# Create the gis db
"${psql[@]}" <<- 'EOSQL'
CREATE DATABASE gis;
EOSQL

# Load PostGIS into 'gis'
echo "Loading PostGIS extensions into 'gis'"
"${psql[@]}" --dbname="gis" <<-'EOSQL'
CREATE EXTENSION IF NOT EXISTS postgis;
EOSQL

num_files=`ls /data/import/*.osm | wc -l`

if (( num_files > 0 )); then
    PBF_FILE=""
    if (( num_files > 1 )); then
        osmosis_cmd="osmosis"
        first=true
        for i in /data/import/*.osm; do
            osmosis_cmd="$osmosis_cmd --rx $i"
            if $first; then
                first=false
            else
                osmosis_cmd="$osmosis_cmd --merge"
            fi
        done 
        PBF_FILE="/data/merged_files.osm.pbf"
        $osmosis_cmd --wb $PBF_FILE
    else
        PBF_FILE=/data/import/`ls /data/import/`
    fi
    osm2pgsql -d gis $PBF_FILE
fi

