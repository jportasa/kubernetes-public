#!/bin/bash

MICROSERVICE=wtn-audit
ENV=dev

#Shared Vars
kubectl get configmap | grep -q shared-configmap || kubectl create -f ../../conf/shared-configmap.yaml
#Specific Vars
kubectl get configmap | grep -q $MICROSERVICE-env-specific-configmap || kubectl create -f ./$MICROSERVICE-configmap.yaml

#Shared secret vars
#kubectl get secret | grep -q shared-secret        || kubectl create -f ../../../../../docker-private/$ENV/shared/shared-secret.yaml
#Specific secret vars
#kubectl get secret | grep -q $MICROSERVICE-secret || kubectl create -f ../../../../../docker-private/$ENV/specific/$MICROSERVICE-secret.yaml

#Infraestructure
kubectl create -f $MICROSERVICE-volumes.yaml
cat $MICROSERVICE-deployment.yaml | sed -e "s/java8-1\/$MICROSERVICE/sistemas\/java8-gradle/" | kubectl create -f -
kubectl get svc | grep -q $MICROSERVICE || kubectl create -f $MICROSERVICE-service.yaml