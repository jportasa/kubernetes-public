#!/bin/bash

source $(dirname $0)/00_entorno.cfg

SQLLINE="alter database ${PGDATABASE} owner to app;"
${PSQLBIN} -d ${PGADMDB} -U ${PGADMUSER} -h ${PGHOST} -p ${PGPORT} -c "${SQLLINE}"
