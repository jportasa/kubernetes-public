Instalación de Portus (registry con interfaz gráfica)
=====================================================

Portus: http://port.us.org

Modificamos las opciones de docker para que admita certificados autofirmados y para que use el directorio /mnt/docker para guardar las imagenes
```
vi /etc/default/docker
DOCKER_OPTS="--insecure-registry=registry.wtransnet.local:5000 -g /mnt/docker --log-opt=max-size=50m --log-opt=max-file=3"

service docker restart
```
Hacer un git clone del proyecto Portus:
```
git clone https://github.com/SUSE/Portus.git
```

root@intk8s02:/git/Portus
El fichero ".env" que usará el docker-compose.yml, cambiar las variables a lo que corresponda:
```
MACHINE_FQDN=10.3.1.201
REGISTRY_PORT=5000
```
El fichero docker-compose.yml contiene toda la estructura de containers que se creará: un webserver, un registry, una DB,...

Bajar el docker-compose, es un aherramienta de docker para hacer despliegues masivos de containers:
https://github.com/docker/compose/releases
```
mv docker-compose-Linux-x86_64 /usr/local/bin/docker-compose
root@intk8s02:/git/Portus# docker compose up -d
```
y nos deja aarrancado esto:
```
root@intk8s02:/git/Portus# docker ps
CONTAINER ID        IMAGE                              COMMAND                  CREATED              STATUS              PORTS                              NAMES
79ed68f68e97        opensuse/portus:development        "./bin/crono"            41 seconds ago       Up 15 seconds       3000/tcp                           portus_crono_1
ff0d3abe59a3        library/registry:2.3.1             "/bin/registry /etc/d"   41 seconds ago       Up 14 seconds       0.0.0.0:5000-5001->5000-5001/tcp   portus_registry_1
f396954ce24d        opensuse/portus:development        "bash /srv/Portus/exa"   About a minute ago   Up 41 seconds       0.0.0.0:3000->3000/tcp             portus_portus_1
db6e21e3df17        library/mariadb:10.0.23            "/docker-entrypoint.s"   About a minute ago   Up About a minute   3306/tcp                           portus_db_1
8211a4eff40d        kkarczmarczyk/node-yarn:6.9-slim   "bash /srv/Portus/exa"   About a minute ago   Up About a minute                                      portus_webpack_1
```
En unos minutos ya podremos acceder vía web a http://10.3.1.201:3000

