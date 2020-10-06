#!/usr/bin/env bash

# Stop the NCEAS NGINX Ingress Controller 
kubectl delete -f common/nginx-config.yaml
kubectl delete -f nceas-virtual-server.yaml
kubectl delete -f service/nodeport.yaml
kubectl delete -f deployment/nginx-ingress.yaml
kubectl delete -f bookkeeper-virtual-server-route.yaml
kubectl delete -f metadig-virtual-server-route.yaml
