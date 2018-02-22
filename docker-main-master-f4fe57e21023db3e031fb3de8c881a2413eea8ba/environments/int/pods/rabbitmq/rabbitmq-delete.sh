#!/bin/bash
kubectl delete svc rabbitmq
kubectl delete deploy rabbitmq
kubectl delete pvc pvc-rabbitmq
kubectl delete pv pv-rabbitmq
kubectl delete configmap rabbitmq-env-specific-configmap

