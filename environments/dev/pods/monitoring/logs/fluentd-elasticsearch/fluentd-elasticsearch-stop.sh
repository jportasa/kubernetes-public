#!/bin/bash

NAMESPACE=sistemas
kubectl delete svc kibana-logging -n $NAMESPACE
kubectl delete deployment kibana-logging -n $NAMESPACE
kubectl delete daemonset fluentd-es-v1.22 -n $NAMESPACE
kubectl delete svc elasticsearch-logging -n $NAMESPACE
kubectl delete rc elasticsearch-logging-v1 -n $NAMESPACE