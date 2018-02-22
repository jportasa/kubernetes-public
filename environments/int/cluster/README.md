Instalacion del cluster k8s con kubeadm y network Weave
=======================================================

Docu: 

http://cloudgeekz.com/1293/kube-dev-environment-modification.html

https://kubernetes.io/docs/getting-started-guides/kubeadm/

En el master y en los slaves:
```
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
#Install docker if you don't have it already.
apt-get install -y docker.io
apt-get install -y kubelet=1.6.4-00
apt-get install -y kubeadm=1.6.4-00
apt-get install -y kubernetes-cni=0.5.1-00
apt-get install -y kubectl=1.6.4-00
```
Config docker para uso de registry inseguro, el path de los ficheros y imagenes de docker y rotación de logs:
```
/etc/default/docker
DOCKER_OPTS="--insecure-registry=registry.wtransnet.local:5000 -g /mnt/docker --log-opt=max-size=5m --log-opt=max-file=3"
service docker restart
```
En el master:
```
sudo su -
ETH0_IP=`ifconfig eth0 | grep inet | awk '{print $2}' | cut -d':' -f2`
kubeadm init --kubernetes-version v1.6.4 --pod-network-cidr 192.168.69.0/24 --apiserver-advertise-address=$ETH0_IP
```
Docu: versiones de k8s: https://github.com/kubernetes/kubernetes/releases

To start using your cluster, you need to run (as a regular user):

En el master:
```
  sudo cp /etc/kubernetes/admin.conf $HOME/
  sudo chown $(id -u):$(id -g) $HOME/admin.conf
  export KUBECONFIG=$HOME/admin.conf
```

Habilito el master para que puedan correr POD's allí:
```
kubectl taint nodes --all node-role.kubernetes.io/master-
```

Instalamos la parete de networking (CNI WEAVE):
Docu: https://www.weave.works/docs/net/latest/kube-addon/
```
kubectl apply -n kube-system -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=192.168.69.0/24"
```
Esperamos a que todos los POD's de namespace kube-system esten Running
```
kubectl get pods -n kube-system
```
Conectamos los otros nodos al master:
```
sudo su -
kubeadm join --token XXXXXXXXXXXXXXXXXXXXX 192.168.43.190:6443
```
Habilitar el configmap que permite que los POD's puedena acceder al registry para bajarse imagenes:
```
kubectl create secret docker-registry registrypullsecret --docker-server=registry.wtransnet.local:5000 --docker-username=adminwtn --docker-password=adminwtn --docker-email=none@none.com
kubectl create secret docker-registry registrypullsecret --docker-server=registry.wtransnet.local:5000 --docker-username=adminwtn --docker-password=adminwtn --docker-email=none@none.com -n sysops
```
Hay PODS que los forzamos a que corran en un nodo determinado (nodeSelector), por ello, definimos labels para los nodos:
```
# Docu: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
NODE1=kubernetes1.wtransnet.local
NODE2=kubernetes2.wtransnet.local
kubectl label nodes $NODE1 name=$NODE1
kubectl label nodes $NODE2 name=$NODE2
```
Eliminar un nodo del cluster
==================================
Docu: https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#limitations

To undo what kubeadm did, you should first drain the node and make sure that the node is empty before shutting it down.
Talking to the master with the appropriate credentials, run:
```
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
kubectl delete node <node name>
```
Then, on the node being removed, reset all kubeadm installed state:
```
kubeadm reset
```
If you wish to start over simply run kubeadm init or kubeadm join with the appropriate arguments.

Mover nuevos POD's a otros nodos
=================================

Docu: http://janetkuo.github.io/docs/user-guide/kubectl/kubectl_cordon/
```
kubectl cordon <NODENAME>
```
Ahora recreo el POD y tiene que moverse de nodo
para desactivar el cordon:
```
kubectl uncordon <NODENAME>
```


Cambios de contexto
======================
```
kubectl config set-context sysops --namespace=sysops
kubectl config use-context sysops
```

Añadir API
================
Por ejemplo tenemos un manigest tipo:
```
apiVersion: batch/v2alpha1
kind: CronJob
metadata:
```
Pero el kubelet no tiene la API batch/v2alpha1
```
root@kubernetes1:/etc/kubernetes/manifests# kubectl api-versions
apps/v1beta1
authentication.k8s.io/v1
authentication.k8s.io/v1beta1
authorization.k8s.io/v1
authorization.k8s.io/v1beta1
autoscaling/v1
batch/v1
certificates.k8s.io/v1beta1
extensions/v1beta1
policy/v1beta1
rbac.authorization.k8s.io/v1alpha1
rbac.authorization.k8s.io/v1beta1
settings.k8s.io/v1alpha1
storage.k8s.io/v1
storage.k8s.io/v1beta1
v1
```
Editamos /etc/kubernetes/manifests/kube-apiserver.yaml
y añadimos:
```
spec:
  containers:
  - command:
  (...)
    - --runtime-config=batch/v2alpha1=true
```
y reiniciamos kubelet (¿¿¿¿¿reinicio maquina entera????un poco bruto nooo??)
