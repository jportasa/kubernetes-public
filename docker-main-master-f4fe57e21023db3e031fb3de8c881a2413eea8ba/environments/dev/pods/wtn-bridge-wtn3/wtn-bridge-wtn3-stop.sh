#!/bin/bash

MICROSERVICE=wtn-bridge-wtn3
ENV=dev

#Specific Vars
kubectl delete -f         $MICROSERVICE-configmap.yaml

#Infraestructure
kubectl delete -f         $MICROSERVICE-volumes.yaml
kubectl delete -f         $MICROSERVICE-deployment.yaml
kubectl delete -f         $MICROSERVICE-service.yaml