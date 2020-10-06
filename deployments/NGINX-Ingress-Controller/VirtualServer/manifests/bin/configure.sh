#!/usr/bin/env bash 

# This script creates the k8s resources needed to run the NGINX, Inc
# k8s Ingress Controller that uses the custom resource VirtualServer
# This script only needs to be run once.

kubectl apply -f common/ns-and-sa.yaml
kubectl apply -f rbac/rbac.yaml
kubectl apply -f common/default-server-secret.yaml
kubectl apply -f common/vs-definition.yaml
kubectl apply -f common/vsr-definition.yaml
kubectl apply -f common/ts-definition.yaml
kubectl apply -f common/gc-definition.yaml
kubectl apply -f common/global-configuration.yaml
