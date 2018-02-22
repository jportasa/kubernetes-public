#!/bin/bash

kubectl delete -f kibana-service.yaml
kubectl delete -f kibana-controller.yaml
kubectl delete -f fluentd-es-ds.yaml
kubectl delete -f es-service.yaml
kubectl delete -f es-controller.yaml
kubectl delete -f es-volumes.yaml
