#!/bin/bash

kubectl create configmap cron-scripts-configmap --from-file=./cron-scripts
kubectl create configmap cron-schedule-configmap --from-file=./cron-schedule
kubectl create -f cron-volumes.yaml
kubectl create -f cron-deployment.yaml

