# Jetstream Auth Learning

This repo contains some examples on how to setup AuthN/AuthZ on NATS servers.

## TLS Certificate Auth

https://docs.nats.io/nats-server/configuration/securing_nats/auth_intro/tls_mutual_auth

```bash
make create-cluster
make install-nats-with-jwt-auth
```


Subscribe
```bash
nats sub --tlscert=/etc/nats-certs/clients/form3-user-cert-tls/tls.crt --tlskey=/etc/nats-certs/clients/form3-user-cert-tls/tls.key --tlsca=/etc/nats-certs/clients/form3-user-cert-tls/ca.crt payments.done
```


Check server list
```
nats server ls --tlscert=/etc/nats-certs/clients/systemaccount-cert-tls/tls.crt --tlskey=/etc/nats-certs/clients/systemaccount-cert-tls/tls.key --tlsca=/etc/nats-certs/clients/systemaccount-cert-tls/ca.crt
```

## JWT Auth

https://docs.nats.io/nats-server/configuration/securing_nats/jwt

To bootstrap the cluster with JWT Auth support just run the following commands:

```bash
make create-cluster
make install-nats-with-jwt-auth
```

Shell into the nats-boxes with the pre-baked credentials and run the following commands to publish and subscribe on payments subject.


readmodelservice-box
```bash
nats sub --tlscert=/etc/nats-certs/clients/nats-client-tls/tls.crt --tlskey=/etc/nats-certs/clients/nats-client-tls/tls.key --tlsca=/etc/nats-certs/clients/nats-client-tls/ca.crt --creds=/etc/nats-creds/readmodelservice/readmodelservice.creds payments.done
```

paymentservice-box
```bash
nats pub --tlscert=/etc/nats-certs/clients/nats-client-tls/tls.crt --tlskey=/etc/nats-certs/clients/nats-client-tls/tls.key --tlsca=/etc/nats-certs/clients/nats-client-tls/ca.crt --creds=/etc/nats-creds/paymentservice/paymentservice.creds payments.done message
```

### Generate JWT Tokens for Operator/Accounts/Users

To re-generate jwt tokens run the following command:

```bash
make generate-jwts
```
After the jwts are re-generated, please re-apply the nats configurations by running:

```bash
make install-nats-with-jwt-auth
```

## Destroying the cluster

```bash
make destroy-cluster
```
