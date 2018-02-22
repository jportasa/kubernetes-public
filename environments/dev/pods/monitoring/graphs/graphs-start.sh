#!/bin/bash

kubecl create -f ./influxdb/influxdb.yaml
kubecl create -f ./heapster/heapster.yaml
kubecl create -f ./grafana/grafana.yaml
