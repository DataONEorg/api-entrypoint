#!/usr/bin/env bash

# This script displays the k8s 'secret' that contains the
# Let's Encrypt Certificate that is used by the NGINX Ingress
# Controller for TLS termination.

kubectl get secret -n nginx-ingress
echo ""
kubectl describe  secret nginx-ingress-tls-cert -n nginx-ingress
