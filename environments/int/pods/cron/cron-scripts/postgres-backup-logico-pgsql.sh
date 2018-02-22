#!/bin/bash


CONFIG=`dirname $0`/`basename $0 .sh`.cfg

. $CONFIG

#mkdir -p $LOGSDIR
#mkdir -p $DESTINO


# Limpiamos el destino. Eliminamos todos los backups.
find $DESTINO -maxdepth 1 -name "*.dmp" -type d -mtime +$DIAS_A_MANTENER -exec rm -r {} \;
find $DESTINO -maxdepth 1 -name "*.dmp" -type f -mtime +$DIAS_A_MANTENER -exec rm {} \;

#exec 1>$LOGPROC
#exec 2>&1

echo Comenzamos - $(date)

trap "ERR=2" ERR
ERR=0

PARAMETROS_DUMP="-h $PGHOST -U $PGUSER -p $PGPORT -d $BD -Fd -f $DUMPDIR -w"
if [ "$NIVEL" == "ESQUEMA" ]
then
  for e in $ESQUEMAS_BD
  do
    PARAMETROS_DUMP="$PARAMETROS_DUMP -n $e"
  done
fi

INICIO=$(date +%s)
/usr/bin/pg_dump $PARAMETROS_DUMP
/usr/bin/pg_dumpall -h $PGHOST -U $PGUSER -p $PGPORT -f $DUMPALLFILE -g -w
FINAL=$(date +%s)
TIEMPO=$((FINAL-INICIO))

echo
echo "Backup logico generado"
/usr/bin/pg_restore -l $DUMPDIR


if [ $ERR -ne 0 ]
then
  ASUNTO="(ERROR) Backup logico Postgres $BD $NIVEL - $(uname -n)"
else
  ASUNTO="(OK) Backup logico Postgres $BD $NIVEL - $(uname -n) ($TIEMPO segs)"
fi


echo Enviamos mail con asunto: $ASUNTO

echo Finalizamos - $(date)

mail -s "$ASUNTO" $NOTIFICACION < $LOGPROC

exit $ERR