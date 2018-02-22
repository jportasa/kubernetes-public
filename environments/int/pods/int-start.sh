#!/bin/bash

echo "-----------Elimino infraestructura existente----------------"
kubectl delete svc,deployments,pods,pv,pvc,rc,configmaps,ingress,limitrange,secret,daemonset --all -n default
kubectl delete svc,deployments,pods,pv,pvc,rc,configmaps,ingress,limitrange,secret,daemonset --all -n sysops

echo "-----------Secret para el pull del registry desde default y kube-system------------------"
kubectl create secret docker-registry registrypullsecret --docker-server=registry.wtransnet.local:5000 --docker-username=adminwtn --docker-password=adminwtn --docker-email=none@none.com
kubectl create secret docker-registry registrypullsecret --docker-server=registry.wtransnet.local:5000 --docker-username=adminwtn --docker-password=adminwtn --docker-email=none@none.com -n sysops
kubectl create secret docker-registry registrypullsecret --docker-server=registry.wtransnet.local:5000 --docker-username=adminwtn --docker-password=adminwtn --docker-email=none@none.com -n kube-system

echo "-----------node labels-----------"
#Docu: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
NODE1=kubernetes1.wtransnet.local
NODE2=kubernetes2.wtransnet.local
kubectl label nodes $NODE1 name=$NODE1
kubectl label nodes $NODE2 name=$NODE2

#echo "-----------Limites de CPU/RAM--------------------"
#kubectl create -f resource-limits.yaml

echo " ----------postgres------------------"
cd postgres/9.5
bash ./postgres-start.sh
cd ../..

echo " ----------rabbit--------------------"
cd rabbitmq
bash ./rabbitmq-start.sh
cd ..

echo " ----------redis---------------------"
cd redis
bash ./redis-start.sh
cd ..

echo " ----------gluster---------------------"
cd gluster/master
bash ./gluster-master-start.sh
cd ../..

echo " ----------web-nginx-----------------"
cd web-nginx
bash ./web-nginx-start.sh
cd ..

echo " ----------wtn-auth------------------"
cd wtn-auth
bash  ./wtn-auth-start.sh
cd ..

echo " ----------wtn-file-upload-----------"
cd wtn-file-upload
bash  ./wtn-file-upload-start.sh
cd ..

echo " ----------wtn-remote-log------------"
cd wtn-remote-log
bash  ./wtn-remote-log-start.sh
cd ..

echo " ----------wtn-bridge-wtn3------------"
cd wtn-bridge-wtn3
bash ./wtn-bridge-wtn3-start.sh
cd ..

echo " ----------wtn-geo-searcher------------"
cd wtn-geo-searcher
bash  ./wtn-geo-searcher-start.sh
cd ..

echo " ----------wtn-credit------------"
cd wtn-credit
bash  ./wtn-credit-start.sh
cd ..

echo " ----------wtn-tracking------------"
cd wtn-tracking
bash  ./wtn-tracking-start.sh
cd ..

echo " ----------wtn-email------------"
cd wtn-email
bash  ./wtn-email-start.sh
cd ..

echo " ----------load-balancer-------------"
cd ./lb-nginx
bash  ./nginx-ingress-lb-start.sh
cd ..

#echo " ---------EFK (Kibana port IP_NODO:31050)-------------"
#cd ./fluentd-elasticsearch
#bash  ./fluentd-elasticsearch-start.sh
#cd ..


