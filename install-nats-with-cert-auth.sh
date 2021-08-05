#!/usr/bin/env bash

kubectl apply -f ./cert-auth/form3-user-cert.yaml \
   --namespace default \
   --context kind-kind

kubectl apply -f ./cert-auth/systemaccount-cert.yaml \
   --namespace default \
   --context kind-kind

kubectl apply -f ./cert-auth/nats-box-with-cert.yaml \
   --namespace default \
   --context kind-kind

helm upgrade -i nats nats/nats \
   --namespace default \
   --kube-context kind-kind \
   -f ./cert-auth/nats-values.yaml
