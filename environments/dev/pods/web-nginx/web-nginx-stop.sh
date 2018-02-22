#!/bin/bash

kubectl delete configmap web-nginx-sites-enabled-configmap
kubectl delete -f web-nginx-deployment.yaml
kubectl delete -f web-nginx-service.yaml
kubectl delete -f web-nginx-volumes.yaml
