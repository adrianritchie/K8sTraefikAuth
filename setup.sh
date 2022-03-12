minikube start --vm-driver=kvm \
    --extra-config=apiserver.service-node-port-range=1-65535 \
    --cpus=4

helm upgrade --install keycloak -n keycloak --create-namespace bitnami/keycloak \
    -f answers.keycloak.yaml

helm upgrade --install traefik traefik/traefik -n traefik --create-namespace \
    -f answers.traefik.yaml \
    -f answers.traefik.secrets.yaml
    
kubectl apply -n traefik -f traefik-dashboard.yaml 
kubectl apply -n keycloak keycloak-ingress.yaml 
kubectl apply -n keycloak -f keycloak-ingress.yaml 
kubectl apply -n default nginx-sample.yaml 
kubectl apply -n default -f nginx-sample.yaml 
kubectl apply -n default -f forwardauth.yaml -f forwardauth-secrets.yaml -f forwardauth-config.yaml
