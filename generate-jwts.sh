#!/bin/sh

rm -rf ./jwt-auth/jwt

export NKEYS_PATH=$(pwd)/jwt-auth/jwt/nsc/nkeys
export NSC_HOME=$(pwd)/jwt-auth/jwt/accounts

mkdir -p "$NKEYS_PATH"
mkdir -p "$NSC_HOME"

nsc add operator --name form3

# Create system account
nsc add account --name SYS
nsc add user    --name sys

# Create payment service account
nsc add account --name paymentservice
nsc add user -a paymentservice \
             --name paymentservice \
             --allow-pub 'payments.>'

kubectl create secret generic paymentservice-nats-creds \
    --dry-run=client -oyaml \
    --from-file=./jwt-auth/jwt/nsc/nkeys/creds/form3/paymentservice/paymentservice.creds \
    > ./jwt-auth/paymentservice-nats-creds.yaml

# Create readmodelservice account
nsc add account --name readmodelservice
nsc add user -a readmodelservice \
             --name readmodelservice \
             --allow-sub 'payments.>'

kubectl create secret generic readmodelservice-nats-creds \
    --dry-run=client -oyaml \
    --from-file=./jwt-auth/jwt/nsc/nkeys/creds/form3/readmodelservice/readmodelservice.creds \
    > ./jwt-auth/readmodelservice-nats-creds.yaml


OPERATOR_JWT=$(cat ./jwt-auth/jwt/accounts/nats/form3/form3.jwt)
SYSTEM_ACCOUNT_PUBLICKEY=$(cat ./jwt-auth/jwt/accounts/nats/form3/accounts/SYS/SYS.jwt | jq -R 'split(".") | .[1] | @base64d | fromjson' | jq '.sub' --raw-output)
SYSTEM_ACCOUNT_JWT=$(cat ./jwt-auth/jwt/accounts/nats/form3/accounts/SYS/SYS.jwt)
PAYMENTSERVICE_PUBLICKEY=$(cat ./jwt-auth/jwt/accounts/nats/form3/accounts/paymentservice/paymentservice.jwt | jq -R 'split(".") | .[1] | @base64d | fromjson' | jq '.sub' --raw-output)
PAYMENTSERVICE_JWT=$(cat ./jwt-auth/jwt/accounts/nats/form3/accounts/paymentservice/paymentservice.jwt)
READMODELSERVICE_PUBLICKEY=$(cat ./jwt-auth/jwt/accounts/nats/form3/accounts/readmodelservice/readmodelservice.jwt | jq -R 'split(".") | .[1] | @base64d | fromjson' | jq '.sub' --raw-output)
READMODELSERVICE_JWT=$(cat ./jwt-auth/jwt/accounts/nats/form3/accounts/readmodelservice/readmodelservice.jwt)

cat <<EOT > ./jwt-auth/nats-account-resolver.yaml
apiVersion: v1
data:
  resolver.conf: |
    resolver: MEMORY
    operator: $OPERATOR_JWT
    system_account: $SYSTEM_ACCOUNT_PUBLICKEY
    resolver_preload: {
      // Account "paymentservice"
      $PAYMENTSERVICE_PUBLICKEY: $PAYMENTSERVICE_JWT

      // Account "readmodelservice"
      $READMODELSERVICE_PUBLICKEY: $READMODELSERVICE_JWT

      // Account "SYS"
      $SYSTEM_ACCOUNT_PUBLICKEY: $SYSTEM_ACCOUNT_JWT
    }
kind: ConfigMap
metadata:
  name: nats-account-resolver
EOT
