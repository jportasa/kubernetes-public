#!/bin/bash

MICROSERVICE=jenkins

kubectl create secret docker-registry registrypullsecret --docker-server=registry.wtransnet.local:5000 --docker-username=adminwtn --docker-password=adminwtn --docker-email=none@none.com -n ci

#Specific Vars
kubectl create -f ./$MICROSERVICE-configmap.yaml
#Secrets para acceder al los clusters de int, pre, pro, uat
kubectl get secret -n ci | grep -q jenkins-k8s-admin-int-secret || kubectl create secret generic jenkins-k8s-admin-int-secret --from-file="../../../../../docker-private/pro/specific/admin-int.conf" -n ci

#Infraestructure
kubectl create -f $MICROSERVICE-volumes.yaml
kubectl create -f $MICROSERVICE-deployment.yaml
kubectl create -f $MICROSERVICE-service.yaml