#!/bin/bash

kubectl delete configmap web-nginx-wtn-tracking-web-sites-enabled-configmap
kubectl delete -f web-nginx-wtn-tracking-web-deployment.yaml
kubectl delete -f web-nginx-wtn-tracking-web-statistics-service.yaml
kubectl delete -f web-nginx-wtn-tracking-web-service.yaml
kubectl delete -f web-nginx-wtn-tracking-web-volumes.yaml
