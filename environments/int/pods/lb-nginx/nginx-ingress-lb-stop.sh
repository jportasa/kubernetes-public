#!/bin/bash

kubectl delete -f nginx-ingress-lb-service.yaml
kubectl delete -f nginx-ingress-lb-daemonset.yaml
kubectl delete -f lb-nginx-configmap.yaml
kubectl delete -f default-http-backend-deployment.yaml
kubectl delete -f nginx-ingress-lb-ingress.yaml
kubectl delete -f default-http-backend-namespace.yaml
kubectl delete -f nginx-ingress-lb-rbac.yaml