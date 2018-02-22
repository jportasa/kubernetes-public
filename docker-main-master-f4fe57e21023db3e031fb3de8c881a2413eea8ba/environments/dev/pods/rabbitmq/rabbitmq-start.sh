#!/bin/bash

kubectl create -f rabbitmq-configmap.yaml
kubectl create -f rabbitmq-deployment.yaml
kubectl create -f rabbitmq-service.yaml