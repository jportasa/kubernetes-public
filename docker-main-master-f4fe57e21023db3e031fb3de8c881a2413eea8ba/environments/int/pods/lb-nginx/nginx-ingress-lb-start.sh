#!/bin/bash

kubectl create clusterrolebinding permissive-binding \
  --clusterrole=cluster-admin \
  --user=admin \
  --user=kubelet \
  --group=system:serviceaccounts

kubectl create -f nginx-ingress-lb-rbac.yaml
kubectl create -f default-http-backend-namespace.yaml
kubectl create -f nginx-ingress-lb-ingress.yaml
kubectl create -f default-http-backend-deployment.yaml
kubectl create -f lb-nginx-configmap.yaml
kubectl create -f nginx-ingress-lb-daemonset.yaml
kubectl create -f nginx-ingress-lb-service.yaml