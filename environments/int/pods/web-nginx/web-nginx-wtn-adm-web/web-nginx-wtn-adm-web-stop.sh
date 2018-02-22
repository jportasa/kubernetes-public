#!/bin/bash

kubectl delete configmap web-nginx-wtn-adm-web-sites-enabled-configmap
kubectl delete -f web-nginx-wtn-adm-web-deployment.yaml
kubectl delete -f web-nginx-wtn-adm-web-statistics-service.yaml
kubectl delete -f web-nginx-wtn-adm-web-service.yaml
kubectl delete -f web-nginx-wtn-adm-web-volumes.yaml
