#!/bin/sh
# start-cron.sh

crontab /etc/cron.d/cron-schedule.txt
/usr/sbin/sshd -D
cron -f