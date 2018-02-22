#!/bin/bash

kubecl delete -f ./influxdb/influxdb.yaml
kubecl delete -f ./heapster/heapster.yaml
kubecl delete -f ./grafana/grafana.yaml