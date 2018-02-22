#!/bin/bash
 kubectl get configmap | grep -q env-configmap || kubectl create -f ../../../conf/env-configmap.yaml
