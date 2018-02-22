#!/bin/bash
kubectl create configmap web-nginx-wtn-tracking-web-sites-enabled-configmap --from-file=../config/sites-enabled
kubectl create -f web-nginx-wtn-tracking-web-volumes.yaml
kubectl create -f web-nginx-wtn-tracking-web-deployment.yaml
kubectl create -f web-nginx-wtn-tracking-web-service.yaml
kubectl create -f web-nginx-wtn-tracking-web-statistics-service.yaml
