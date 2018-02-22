# Minikube, instalacion en MAC OS

**Descargar VirtualBox**

https://www.virtualbox.org/

**Descargar minikube for MAC OSX**

Docu: https://github.com/kubernetes/minikube/releases
```
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.18.0/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```
**Descargar kubectl for OSX:**

Docu: https://kubernetes.io/docs/tasks/kubectl/install/
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/v.1.6.0/bin/darwin/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```
**Ver version de kubectl:**
```
kubectl version
```
**Arrancar la VM minikube para que cree la VM dentro de virtualbox.**
```
minikube start --kubernetes-version="1.6.0" --insecure-registry=registry.wtransnet.local:5000 --memory 6144 --cpus 3
```
**Parar minikube**
```
minikube stop
```
**Mapeamos unidades**

Mapeo de ~/docker local a la VM minikube:

Desde OS:
```
/usr/local/VBoxManage sharedfolder add "minikube" --name "docker" --hostpath $HOME/docker --automount
```
Arrancamos de nuevo la VM minikube:

Te recomendamos que tengas 8G de RAM para que puedas tener todos los contendores docker funcionando a la vez.
```
minikube start --kubernetes-version="1.6.0" --insecure-registry=registry.wtransnet.local:5000 --memory 6144 --cpus 3
```
**Descarga de los ficheros de datos que necesita cada POD (container)**
```
rsync -av --delete dev@registry.wtransnet.local:/mnt/docker/volumes $HOME/docker
```
Nota: password=dev

**Arrancamos todos los POD's (containers)**
```
cd ~/git/docker-main/environments/dev/pods
./dev-start.sh
```