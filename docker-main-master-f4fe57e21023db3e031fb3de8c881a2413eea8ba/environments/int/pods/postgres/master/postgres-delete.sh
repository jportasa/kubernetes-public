#!/bin/bash

kubectl delete -f postgres-service.yaml
kubectl delete -f postgres-deployment.yaml
kubectl delete -f postgres-volumes.yaml
kubectl delete configmap postgres-pg1-configmap
