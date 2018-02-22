#!/bin/bash

MICROSERVICE=jenkins

#Specific Vars
kubectl delete -f ./$MICROSERVICE-configmap.yaml

#Infraestructure
kubectl delete -f $MICROSERVICE-service.yaml
kubectl delete -f $MICROSERVICE-deployment.yaml
kubectl delete -f $MICROSERVICE-volumes.yaml

