FROM postgres:9.5
MAINTAINER Philip Beelmann <beelmann@geofabrik.de>

RUN localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8
ENV LANG de_DE.utf8

ENV POSTGIS_MAJOR 2.2
ENV POSTGIS_VERSION 2.2

RUN apt-get update \
      && apt-get install -y --no-install-recommends --fix-missing \
                 postgresql-9.5-postgis-2.2 \
                 osm2pgsql \
                 osmosis \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh

RUN mkdir -p /data/import

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

EXPOSE 5432
