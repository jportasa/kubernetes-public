#!/bin/bash

#Script de instalacion de minikube+kubectl+kubernetes

KUBECTL_RELEASE="v1.6.4"
MINIKUBE_RELEASE="v0.16.0"
KUBERNETES_RELEASE="v1.6.4"


#Installing VirtualBox
echo "Installing VirtualBox........................"
sudo apt-get install -y virtualbox

#Installing kubectl https://kubernetes.io/docs/getting-started-guides/kubectl/
echo "Installing kubectl..........................."
wget https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_RELEASE/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

#Installing curl
sudo apt-get install -y curl

#Installing minikube https://github.com/kubernetes/minikube/releases
echo "Installing minikube.........................."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/$MINIKUBE_RELEASE/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

#Arranco minikube para que cree la VM en Virtualbox
echo "Starting minikube.........................."
minikube start --kubernetes-version=$KUBERNETES_RELEASE --insecure-registry=registry.wtransnet.local:5000 --memory 6144 --cpus 3

#Paro la VM con minikube para poder hacer el mapeo
echo "Stoping minikube.........................."
minikube stop

#Otros comandos interesantes
#minikube delete -->me cargo todo el minikube por completo

#Monto mapeo virtual box /docker del ubunutu local<---->/docker en minikube
echo "Mapping shared folders in virtual box.........................."
#mkdir /home/administrador/docker
#mkdir /home/administrador/git
mkdir /docker
mkdir /git
#vboxmanage sharedfolder add "minikube" --name "docker" --hostpath /home/administrador/docker --automount
#vboxmanage sharedfolder add "minikube" --name "git"    --hostpath /home/administrador/git --automount
vboxmanage sharedfolder add "minikube" --name "docker" --hostpath /docker --automount
vboxmanage sharedfolder add "minikube" --name "git"    --hostpath /git --automount

#Compruebo los sharedfolders:
vboxmanage showvminfo minikube

#Arranco minikube para que cree la VM en Virtualbox
echo "Starting minikube.........................."
minikube start --kubernetes-version=$KUBERNETES_RELEASE --insecure-registry=registry.wtransnet.local:5000 --memory 6144 --cpus 3

echo "Recuerda que:"
echo "Para usar comandos "kubectl" tienes que ser root!"
echo "Tu directorio git de trabajo tiene que estar en  /git"
echo "Los volumenes de datos persistentes de los contenedores tienen que estar en /docker/volumes/..."