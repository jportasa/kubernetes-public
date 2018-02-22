#!/bin/bash


echo "Descargo en local ultima version filesystem frontend de INT"
echo "Password=dev"
rsync  -Cavz --delete dev@registry.wtransnet.local:/mnt/docker/volumes/web-nginx/pv-web-nginx-www/ /home/administrador/docker/volumes/web-nginx/pv-web-nginx-www/
echo "============================="
echo "Descarga finalizada, ficheros en C:/docker/volumes/web-nginx/pv-web-nginx-www/"
