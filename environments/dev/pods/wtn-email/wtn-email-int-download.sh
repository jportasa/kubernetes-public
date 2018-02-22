#!/bin/bash

echo "Descargo del NAS en local ultima version filesystem templates de INT"
scp -r dev@registry.wtransnet.local:/mnt/docker/volumes/wtn-email/pv-wtn-email/* /c/docker/volumes/wtn-email/pv-wtn-email/
echo "============================="
echo "Descarga finalizada, ficheros en wtn-email/pv-wtn-email/"