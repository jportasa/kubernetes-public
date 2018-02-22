#!/bin/bash

MICROSERVICE=cron
ENV=int

#Specific secret vars
kubectl delete secret $MICROSERVICE-secret

kubectl delete -f cron-service.yaml
kubectl delete -f cron-deployment.yaml
kubectl delete -f cron-volumes.yaml
kubectl delete configmap cron-scripts-configmap
kubectl delete configmap cron-schedule-configmap
