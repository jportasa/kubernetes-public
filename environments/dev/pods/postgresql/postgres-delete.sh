#!/bin/bash

kubectl delete svc postgres
kubectl delete deploy postgres

kubectl delete pvc pvc-postgres-etc
kubectl delete pvc pvc-postgres-lib
kubectl delete pvc pvc-postgres-pgdata
kubectl delete pvc pvc-postgres-dump

kubectl delete pv pv-postgres-etc
kubectl delete pv pv-postgres-lib
kubectl delete pv pv-postgres-pgdata
kubectl delete pv pv-postgres-dump

kubectl delete configmap postgres-configmap

