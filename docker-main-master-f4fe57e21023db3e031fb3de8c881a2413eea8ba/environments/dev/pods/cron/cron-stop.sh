#!/bin/bash

kubectl delete -f cron-deployment.yaml
kubectl delete -f cron-volumes.yaml
kubectl delete configmap cron-scripts-configmap
kubectl delete configmap cron-schedule-configmap