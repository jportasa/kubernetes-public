#!/bin/bash

echo "-----------Elimino infraestructura existente----------------"
kubectl delete svc,deployments,pods,pv,pvc,rc,configmaps,ingress,limitrange --all -n default
kubectl delete svc,deployments,pods,pv,pvc,rc,configmaps,ingress,ds,limitrange --all -n sistemas

echo "-----------Secret para el pull del registry desde default y kube-system------------------"
kubectl create secret docker-registry registrypullsecret --docker-server=registry.wtransnet.local:5000 --docker-username=adminwtn --docker-password=adminwtn --docker-email=none@none.com
kubectl create secret docker-registry registrypullsecret --docker-server=registry.wtransnet.local:5000 --docker-username=adminwtn --docker-password=adminwtn --docker-email=none@none.com -n kube-system

echo "-----------Limites de CPU/RAM--------"
kubectl create -f resource-limits.yaml
echo " ----------postgres------------------"
cd ./postgresql
./postgres-start.sh
cd ..
echo " ----------rabbit--------------------"
cd ./rabbitmq
./rabbitmq-start.sh
cd ..
echo " ----------redis---------------------"
cd ./redis
./redis-start.sh
cd ..
echo " ----------web-nginx-----------------"
cd ./web-nginx
./web-nginx-start.sh
cd ../
echo " ----------wtn-auth------------------"
cd ./wtn-auth
./wtn-auth-start.sh
cd ..
echo " ----------wtn-file-upload-----------"
cd ./wtn-file-upload
./wtn-file-upload-start.sh
cd ..
echo " ----------wtn-remote-log------------"
cd ./wtn-remote-log
./wtn-remote-log-start.sh
cd ..
echo " ----------wtn-bridge-wtn3------------"
cd ./wtn-bridge-wtn3
./wtn-bridge-wtn3-start.sh
cd ..
echo " ----------wtn-geo-searcher------------"
cd ./wtn-geo-searcher
./wtn-geo-searcher-start.sh
cd ..
echo " ----------wtn-credit------------"
cd ./wtn-credit
./wtn-credit-start.sh
cd ..
echo " ----------wtn-tracking------------"
cd ./wtn-tracking
./wtn-tracking-start.sh
cd ..
echo " ----------wtn-email------------"
cd ./wtn-email
./wtn-email-start.sh
cd ..
echo " ----------load-balancer-------------"
cd ./lb-nginx
./lb-start.sh
cd ..
#echo " ---------EFK (Kibana port IP_NODO:31050)-------------"
#cd ./fluentd-elasticsearch
#./fluentd-elasticsearch-start.sh
#cd ../..



