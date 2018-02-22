#!/bin/bash
kubectl delete -f redis-service.yaml
kubectl delete -f redis-deployment.yaml
kubectl delete pvc pvc-redis
kubectl delete pv pv-redis

