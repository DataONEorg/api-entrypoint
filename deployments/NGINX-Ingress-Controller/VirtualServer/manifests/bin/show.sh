#!/usr/bin/env bash

# This script displays information about the 
# NGINX Ingress Controller VirtualServer resources 
# that are used by the  NCEAS k8s services

kubectl describe virtualserver -n metadig

kubectl describe virtualserverroute -n metadig

kubectl describe virtualserverroute -n bookkeeper

kubectl describe configmap nginx-config -n nginx-ingress
