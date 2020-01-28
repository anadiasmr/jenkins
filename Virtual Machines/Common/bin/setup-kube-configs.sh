#!/bin/bash

#Reset kube config
find $1/* | grep -v "$1/certificates" | grep -v "$1/personal" | grep -v "$1/auto-create-in-local" | xargs -I '{}' rm -Rf '{}'
cp -rf $1/personal $1/tmp

#Recreate kube home directory
rm -Rf /home/docker/.kube
ln -sf $1 /home/docker/.kube

#Recreate kube config
LOCAL_SERVER_ADDR_PLACEHOLDER="$(cat $1/tmp/minikube-config | grep LOCAL_SERVER_ADDR_PLACEHOLDER)"
LOCAL_SERVER_IP="$(/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2| cut -d' ' -f1)"
LOCAL_SERVER_ADDR="    server: https://$LOCAL_SERVER_IP:8443 #LOCAL_SERVER_ADDR_PLACEHOLDER"
[ ! -z "$LOCAL_SERVER_ADDR_PLACEHOLDER" ] && sed -i "s@$LOCAL_SERVER_ADDR_PLACEHOLDER@$LOCAL_SERVER_ADDR@g" $1/tmp/minikube-config

#Create flatten config
KUBECONFIG="$1/config"
while read x; do
   KUBECONFIG+=:$x
done <<<$(find $1/tmp -type f -iname "*")
export KUBECONFIG=$KUBECONFIG
kubectl config view --flatten > $1/config
KUBECONFIG="$1/config"
rm -Rf $1/tmp

#Automatically create resources in local context
find $1/auto-create-in-local -type f -iname "*.yaml" | while read line; do 
  kubectl create --context local -f "$line"
done 