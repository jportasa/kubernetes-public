#!/bin/bash

kubectl create -f lb-nginx-ingress.yaml
kubectl create -f default-backend.yaml
kubectl create -f lb-nginx-configmap.yaml
kubectl create -f lb-nginx-deployment.yaml
