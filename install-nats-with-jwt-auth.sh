#!/usr/bin/env bash

kubectl apply -f ./jwt-auth/paymentservice-nats-box.yaml \
   --namespace default \
   --context kind-kind

kubectl apply -f ./jwt-auth/paymentservice-nats-creds.yaml \
   --namespace default \
   --context kind-kind

kubectl apply -f ./jwt-auth/readmodelservice-nats-box.yaml \
   --namespace default \
   --context kind-kind

kubectl apply -f ./jwt-auth/readmodelservice-nats-creds.yaml \
   --namespace default \
   --context kind-kind

kubectl apply -f ./jwt-auth/nats-account-resolver.yaml \
   --namespace default \
   --context kind-kind

helm upgrade -i nats nats/nats \
   --namespace default \
   --kube-context kind-kind \
   -f ./jwt-auth/nats-values.yaml
