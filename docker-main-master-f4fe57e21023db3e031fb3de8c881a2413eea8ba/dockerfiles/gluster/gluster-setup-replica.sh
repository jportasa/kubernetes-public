#!/bin/bash 

# Joan Porta
# Replica inicial entre master y slave, 2 nodos
# La variable ISMASTER, NODE1 y NODE2 se dinen en el configmap
# Importante!!! hay que instalar "apt-get install gluster-client" en todos los nodos donde corra gluster

#NODE1=192.168.43.190
#NODE2=192.168.43.191
#ISMASTER="true"
VOLNAME="vol01"
VOLPATH="/mnt/glusterfs/$VOLNAME/brick1"

#En nodo 1 y nodo 2 creo este PATH
   mkdir -p $VOLPATH

# La variable ISMASTER se dine en el configmap
If [ "$ISMASTER" == "true" ]; then
  gluster peer probe $NODE2
  gluster volume create $VOLNAME replica 2 $NODE1:$VOLPATH/brick $NODE2:/$VOLPATH/brick 
  gluster volume start $VOLNAME
fi

# gluster volume status