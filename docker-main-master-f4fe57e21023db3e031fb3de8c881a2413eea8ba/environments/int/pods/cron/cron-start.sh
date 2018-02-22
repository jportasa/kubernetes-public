#!/bin/bash

MICROSERVICE=cron
ENV=int


#Shared Vars
kubectl get configmap | grep -q env-configmap || kubectl create -f ../../conf/shared-configmap.yaml
#Specific secret vars
kubectl get secret | grep -q $MICROSERVICE-secret || kubectl create -f ../../../../../docker-private/$ENV/specific/$MICROSERVICE-secret.yaml

kubectl create configmap cron-scripts-configmap --from-file=./cron-scripts
kubectl create configmap cron-schedule-configmap --from-file=./cron-schedule
kubectl create -f cron-volumes.yaml
kubectl create -f cron-deployment.yaml
kubectl create -f cron-service.yaml

