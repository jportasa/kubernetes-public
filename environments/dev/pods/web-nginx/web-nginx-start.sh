#!/bin/bash

./web-nginx-sites-enabled-configmap.sh
kubectl create -f web-nginx-volumes.yaml
kubectl create -f web-nginx-deployment.yaml
kubectl create -f web-nginx-service.yaml