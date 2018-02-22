#!/bin/bash

#RBAC
kubectl create clusterrolebinding permissive-binding \
  --clusterrole=cluster-admin \
  --user=admin \
  --user=kubelet \
  --group=system:serviceaccounts


kubectl create -f es-volumes.yaml
kubectl create -f es-controller.yaml
kubectl create -f es-service.yaml

kubectl create -f fluentd-es-configmap.yaml
kubectl create -f fluentd-es-ds.yaml

kubectl create -f kibana-controller.yaml
kubectl create -f kibana-service.yaml

