#!/bin/bash
set -e

echo "Arranco gradle...(modo edición del microservicio)"
export TERM=dumb

#La variable MICROSERVICE_NAME se le pasa a través del configmap.
cd /git/$MICROSERVICE_NAME
export PATH=$PATH:/git/$MICROSERVICE_NAME
/git/$MICROSERVICE_NAME/gradlew bootRun


