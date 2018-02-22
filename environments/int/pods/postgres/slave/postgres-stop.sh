#!/bin/bash

kubectl delete -f postgres-service.yaml
kubectl delete -f postgres-deployment.yaml
