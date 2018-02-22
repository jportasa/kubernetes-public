#!/bin/bash

echo "Descargo todos los dumps de postgres de INT en local"
echo "============================="
/usr/bin/scp dev@registry.wtransnet.local:/mnt/docker/volumes/postgres/pv-postgres-runtime/* /c/docker/volumes/postgres/pv-postgres-runtime/
echo "============================="
echo "Descarga finalizada, ficheros descargados en /c/docker/volumes/"