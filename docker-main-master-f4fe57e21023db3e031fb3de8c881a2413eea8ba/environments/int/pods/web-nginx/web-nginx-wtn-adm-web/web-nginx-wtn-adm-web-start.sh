#!/bin/bash
kubectl create configmap web-nginx-wtn-adm-web-sites-enabled-configmap --from-file=../config/sites-enabled
kubectl create -f web-nginx-wtn-adm-web-volumes.yaml
kubectl create -f web-nginx-wtn-adm-web-deployment.yaml
kubectl create -f web-nginx-wtn-adm-web-service.yaml
kubectl create -f web-nginx-wtn-adm-web-statistics-service.yaml
