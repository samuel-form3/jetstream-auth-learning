#!/usr/bin/env bash

helm upgrade -i \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.4.0 \
  --set installCRDs=true \
  --set prometheus.enabled=false \
  --wait=true

kubectl apply -f ./certs/ca-issuer.yaml \
   --namespace default \
   --context kind-kind

kubectl apply -f ./certs/ca-key-pair.yaml \
   --namespace default \
   --context kind-kind

kubectl apply -f ./certs/cert-client-tls.yaml \
   --namespace default \
   --context kind-kind

kubectl apply -f ./certs/cert-server-tls.yaml \
   --namespace default \
   --context kind-kind
