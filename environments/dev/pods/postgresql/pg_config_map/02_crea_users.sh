#!/bin/bash

source $(dirname $0)/00_entorno.cfg

SQLFILE=$(dirname $0)/02_crea_users.sql
${PSQLBIN} -U ${PGADMUSER} -p ${PGPORT} -h ${PGHOST} -d ${PGDATABASE} -f "${SQLFILE}"

