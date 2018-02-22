#!/bin/bash

kubectl create configmap web-nginx-sites-enabled-configmap --from-file=./config/sites-enabled