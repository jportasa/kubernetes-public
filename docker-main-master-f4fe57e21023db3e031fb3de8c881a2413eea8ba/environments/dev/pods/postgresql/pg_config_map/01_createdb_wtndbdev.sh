#!/bin/bash

source $(dirname $0)/00_entorno.cfg

/usr/bin/createdb ${PGDATABASE}
