#!/bin/bash

MICROSERVICE1=redis-master
MICROSERVICE2=redis-slave
ENV=int

#Infraestructure
kubectl create -f ./master/$MICROSERVICE1-volumes.yaml
kubectl create -f ./slave/$MICROSERVICE2-volumes.yaml

kubectl get svc | grep -q $MICROSERVICE1-deployment || kubectl create -f ./master/$MICROSERVICE1-deployment.yaml
kubectl get svc | grep -q $MICROSERVICE2-deployment || kubectl create -f ./master/$MICROSERVICE2-deployment.yaml

kubectl get svc | grep -q $MICROSERVICE1 || kubectl create -f ./master/$MICROSERVICE1-service.yaml
kubectl get svc | grep -q $MICROSERVICE2 || kubectl create -f ./slave/$MICROSERVICE2-service.yaml