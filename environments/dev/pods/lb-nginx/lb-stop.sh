#!/bin/bash

kubectl delete -f lb-nginx-ingress.yaml
kubectl delete -f default-backend.yaml
kubectl delete -f lb-nginx-configmap.yaml
kubectl delete -f lb-nginx-deployment.yaml