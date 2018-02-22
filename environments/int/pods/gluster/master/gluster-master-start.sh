#!/bin/bash

#Docu: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
NODE1=kubernetes1.wtransnet.local
NODE2=kubernetes2.wtransnet.local
kubectl label nodes $NODE1 name=$NODE1
kubectl label nodes $NODE2 name=$NODE2

kubectl create -f gluster-endpoint.yaml
kubectl create -f gluster-master-volumes.yaml
kubectl create -f gluster-master-deployment.yaml
kubectl create -f gluster-master-service.yaml
