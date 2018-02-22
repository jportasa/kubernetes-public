#!/bin/bash

source $(dirname $0)/00_entorno.cfg

SQLLINE="CREATE TABLESPACE wtndb_dat OWNER app LOCATION '/u01/postgres/pgdata/data/wtndbdata';"
${PSQLBIN} -d ${PGDATABASE} -U ${PGADMUSER} -p ${PGPORT} -h ${PGHOST} -c "${SQLLINE}"

SQLLINE="CREATE TABLESPACE wtndb_idx OWNER app LOCATION '/u01/postgres/pgdata/indx/wtndbindx';"
${PSQLBIN} -d ${PGDATABASE} -U ${PGADMUSER} -p ${PGPORT} -h ${PGHOST} -c "${SQLLINE}"
