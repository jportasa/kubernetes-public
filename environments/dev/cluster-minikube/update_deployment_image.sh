#!/bin/bash

# Kubernetes:
# A partir de un deployment que ya esta running, hago un rollup con una nueva imagen.
# Joan Porta 2017

echo $# arguments
if [ $# -ne 3 ]; then
    echo "Illegal number of arguments"
    echo "Usage: $0 <microservice(wtn-auth,...)> <image url(registry.wtransnet.local:5000/java8-1/wtn-auth:1.10.1.BUILD-SNAPSHOT)> <environment(dev, int, pre, pro, uat)>"
    exit 1
fi

MICROSERVICE=$1 
IMAGE_URL=$2
ENV=$3

case "$ENV" in
        dev)  echo "";;
        int)  export KUBECONFIG=$HOME/kubernetes/admin-int.conf;;
        pre)  export KUBECONFIG=$HOME/kubernetes/admin-pre.conf;;
          *)  echo "wrong environment, should be int, pre, pro, demos, uat";;
esac

kubectl set image deployment/$MICROSERVICE $MICROSERVICE=$IMAGE_URL
export KUBECONFIG=""