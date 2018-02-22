Docu Load Balancer Nginx Ingress Controller

Docu: https://github.com/kubernetes/contrib/tree/master/ingress/controllers/nginx/examples
```
RBAC (no posar-ho a PRO pq eés massa permisiu!)
kubectl create clusterrolebinding permissive-binding \
  --clusterrole=cluster-admin \
  --user=admin \
  --user=kubelet \
  --group=system:serviceaccounts
```

Estadísticas del LB (VTS)
===========================
Docu: https://github.com/kubernetes/ingress/tree/master/examples/customization/custom-vts-metrics/nginx