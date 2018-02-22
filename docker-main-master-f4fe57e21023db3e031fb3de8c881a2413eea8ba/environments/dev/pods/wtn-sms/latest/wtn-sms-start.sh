#!/bin/bash

./wtn-sms-env-configmap.sh
./wtn-sms-env-specific-configmap.sh
./wtn-sms-properties-configmap.sh
./wtn-sms-resources-configmap.sh
kubectl create -f wtn-sms-deployment.yaml
kubectl create -f wtn-sms-service.yaml
