# Dockerfile de Postgresql 9.5

FROM registry.cpd.wtransnet.net:5000/sistemas/ubuntu16.04-wtn:latest
MAINTAINER rlopez@wtransnet.com

ENV DEBIAN_FRONTEND noninteractive
ENV DEBUG        true

ENV PGOSUSER     postgres
ENV PGOSUSERID   54321
ENV PGOSGROUP    postgres
ENV PGOSGROUPID  54321

ENV PGDBUSER     postgres
ENV PGDBPASS     postgres
ENV PGPORT       5432
ENV PGVERSION    9.5
ENV PGINITDBARGS "--locale=en_US.UTF-8"

ENV PGHOME       /u01/postgres/pgdata
ENV PGDATA       /u01/postgres/pgdata/main
ENV PGLOG        /u01/postgres/pgdata/main/pg_log
ENV PGXLOG       /u01/postgres/pgdata/xlog

ENV PGWTNBACK    /u01/postgres/pgdata/back
ENV PGWTNDATA    /u01/postgres/pgdata/data
ENV PGWTNINDX    /u01/postgres/pgdata/indx

ENV PGLOGDIR     /var/log/postgresql
ENV PGBINDIR     /usr/lib/postgresql/9.5/bin
ENV PGCFGNDIR    /etc/postgresql/9.5/main

ENV LANG         en_US.utf8
ENV PGDUMPDIR    /mnt/postgres/pgdump
ENV PGINSTALLDIR /mnt/postgres/install


# Usuario y grupo de postgresql
RUN groupadd -r ${PGOSGROUP} --gid=${PGOSGROUPID} \
 && useradd -r -g ${PGOSGROUP} --uid=${PGOSUSERID} ${PGOSUSER}

# Idioma por defecto
RUN apt-get update \
 && apt-get install -y locales \
 && rm -rf /var/lib/apt/lists/* \
 && locale-gen ${LANG}

RUN apt-get update \
 && apt-get install -y wget

# Respositorio de postgresql
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
 && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && apt-get update \
 && apt-get install -y gosu \
 && apt-get install -y postgresql-common \
 && cp /etc/postgresql-common/createcluster.conf /etc/postgresql-common/createcluster.conf.original \
 && sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf \
 && apt-get install -y postgresql-${PGVERSION} postgresql-client-${PGVERSION} postgresql-contrib-${PGVERSION} \
 && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

# Exponemos el puerto de Postgresql
EXPOSE ${PGPORT}

RUN mkdir -p ${PGHOME}
RUN chown -R ${PGOSUSER}.${PGOSGROUP} ${PGHOME}

VOLUME  ["${PGHOME}", "${PGDUMPDIR}", "${PGINSTALLDIR}"]

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["postgres"]
