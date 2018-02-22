#!/bin/bash

MICROSERVICE=wtn-audit
ENV=int

#Specific Vars
kubectl delete -f         $MICROSERVICE-configmap.yaml

#Infraestructure
kubectl delete -f         $MICROSERVICE-volumes.yaml
kubectl delete -f         $MICROSERVICE-deployment.yaml
kubectl delete -f         $MICROSERVICE-service.yaml