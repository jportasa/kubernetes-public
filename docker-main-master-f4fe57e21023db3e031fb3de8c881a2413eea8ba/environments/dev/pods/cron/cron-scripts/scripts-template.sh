#!/bin/bash

# Añadir a este script todos los scripts de cron
# Joan Porta 08/2017

TASK=$1
MAILTO=jporta@wtransnet.com
######################################################################
task_backup() {
  echo "`date +\%Y-\%m-\%d-\%H:\%M:\%S` start task_backup"
  echo "pepe" || return 1
  echo "popo" || return 1
  return 0
}
######################################################################
task_clean() {
  echo "`date +\%Y-\%m-\%d-\%H:\%M:\%S` start task_clean"
  echo "pip" || return 1
  echo "pop" || return 1
  return 0
}
######################################################################
task_elasticsearch_snapshot() {
  echo "`date +\%Y-\%m-\%d-\%H:\%M:\%S` start elasticsearch_snapshot"
  # Creo repopsitorio snapshots  (en el POD de elastic, en /mnt/elasticsearch-snaps)
  curl -X PUT  http://elasticsearch-logging:9200/_snapshot/snaps -d '{"type": "fs", "settings": { "location": "/mnt/elasticsearch-snaps" }}' || return 1
  # Creo snapshot
  curl -X PUT http://elasticsearch-logging:9200/_snapshot/snaps/snapshot_$(date +%Y%m%d-%H%M%S-%s)?wait_for_completion=true || return 1
  return 0
}
######################################################################
task_snapshot_ps500TRS_int-pv-gluster-master-data() {
  echo "`date +\%Y-\%m-\%d-\%H:\%M:\%S` start task_clean"
  ssh grpadmin@192.168.6.81 "volume select int-pv-gluster-master-data snapshot create-now"  || return 1
  return 0
}
######################################################################
#Envía mail en caso de fallo de la task
case "$TASK" in
  backup)        task_backup                 || mailx -s "cron_task_backup failure" $MAILTO;;
  clean )        task_clean                  || mailx -s "cron_task_clean  failure" $MAILTO;;
  elasticsearch) task_elasticsearch_snapshot || mailx -s "cron_task_elasticsearch_snapshot  failure" $MAILTO;;
  gluster)       task_snapshot_ps500TRS_int-pv-gluster-master-data || mailx -s "task_snapshot_ps500TRS_int-pv-gluster-master-data  failure" $MAILTO;;
  *) echo "Task not recognized"
   ;;
esac