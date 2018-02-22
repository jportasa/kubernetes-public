#!/bin/bash
kubectl create configmap postgres-pg2-configmap --from-file=$(dirname $0)/pg_config_map
kubectl create -f postgres-volumes.yaml
kubectl create -f postgres-deployment.yaml
kubectl create -f postgres-service.yaml
