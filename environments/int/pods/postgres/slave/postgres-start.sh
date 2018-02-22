#!/bin/bash
kubectl create -f postgres-deployment.yaml
kubectl create -f postgres-service.yaml
