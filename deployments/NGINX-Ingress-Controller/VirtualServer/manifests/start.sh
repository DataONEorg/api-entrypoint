kubectl apply -f common/nginx-config.yaml
kubectl apply -f deployment/nginx-ingress.yaml
kubectl apply -f service/nodeport.yaml
kubectl apply -f bookkeeper-virtual-server-route.yaml
kubectl apply -f metadig-virtual-server-route.yaml
kubectl apply -f nceas-virtual-server.yaml
