#!/bin/bash
kubectl create secret docker-registry registrypullsecret --docker-server=registry.wtransnet.local:5000 --docker-username=adminwtn --docker-password=adminwtn --docker-email=none@none.com