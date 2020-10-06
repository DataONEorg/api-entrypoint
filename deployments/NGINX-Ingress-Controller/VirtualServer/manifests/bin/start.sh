#!/usr/bin/env bash

# This script starts the NCEAS NGINX Ingress Controller
# using VirtualServer resources for the NCEAS k8s services

# Creates the CORS configuration for the controller
kubectl apply -f common/nginx-config.yaml

# Start the controller
kubectl apply -f deployment/nginx-ingress.yaml

# Create a port that will be used to route traffic to the controller
kubectl apply -f service/nodeport.yaml

# Define the VirtualServerRoute that is used to route traffic to NCEAS bookkeeper service
kubectl apply -f bookkeeper-virtual-server-route.yaml

# Define the VirtualServerRoute that is used to route traffic to the NCEAS MetaDIG quality service
kubectl apply -f metadig-virtual-server-route.yaml
 
# Start the VirtualServer
kubectl apply -f nceas-virtual-server.yaml
