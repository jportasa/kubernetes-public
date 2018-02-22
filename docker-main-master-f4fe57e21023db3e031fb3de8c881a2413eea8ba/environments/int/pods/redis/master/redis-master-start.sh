#!/bin/bash

kubectl create -f redis-master-volumes.yaml
kubectl create -f redis-master-deployment.yaml
kubectl create -f redis-master-service.yaml