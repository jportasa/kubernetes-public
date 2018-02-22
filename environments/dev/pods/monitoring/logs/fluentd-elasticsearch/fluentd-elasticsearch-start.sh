#!/bin/bash
kubectl create -f es-controller.yaml
kubectl create -f es-service.yaml
kubectl create -f fluentd-es-ds.yaml
kubectl create -f kibana-controller.yaml
kubectl create -f kibana-service.yaml

