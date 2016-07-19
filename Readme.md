# Docker Postgis database + Importer

This postgis docker container is based on the [official postgres docker image version 9.5](https://hub.docker.com/_/postgres/) thus using debian:jessie as underlying OS.
It creates a database 'gis' and installs the extension postgis. Further on osmosis and osm2pgsql are installed to be able to merge multiple OSM-files and import the result with osm2pgsql to the database 'gis'.



## Usage
------

**build container:**

docker build -t geofabrik/postgis .

**run geofabrik/postgis container and remove it immediately after it is beeing closed**

docker run --rm --name postgis -v /path/to/desired/import/data:/data/import geofabrik/postgis

or

**run geofabrik/postgis container**

docker run --name postgis -v /path/to/desired/import/data:/data/import geofabrik/postgis

* add "-e POSTGRES_PASSWORD=super_secret_password" to set a password
* docker stop postgis
* docker start postgis

docker rm postgis

e. g.:
docker run --rm --name postgis -e POSTGRES_PASSWORD=pass -v $HOME/Desktop/import:/data/import geofabrik/postgis


## excerpt from 'docker run --help'
```
Usage:  docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
-e, --env=[]                    Set environment variables
-d, --detach                    Run container in background and print container ID
--rm                            Automatically remove the container when it exits
-v, --volume=[]                 Bind mount a volume
```
