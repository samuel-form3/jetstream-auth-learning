#!/usr/bin/env bash

# Account FORM3

# Create Stream
kubectl exec --context=kind-kind -it deploy/nats-box -- nats stream create CENTRAL \
    --tlskey=/etc/nats-certs/form3/tls.key \
    --tlscert=/etc/nats-certs/form3/tls.crt \
    --tlsca=/etc/nats-certs/form3/ca.crt \
    --subjects=central.> \
    --storage=file \
    --retention=limits \
    --discard=old \
    --max-msgs=-1 \
    --max-msgs-per-subject=-1 \
    --max-msg-size=-1 \
    --max-bytes=-1 \
    --dupe-window=2m \
    --max-age=-1 \
    --replicas=1

# Create Pull Consumer
kubectl exec --context=kind-kind -it deploy/nats-box -- nats con add CENTRAL CAFPSPAYMENTSPULLCONSUMER \
    --tlskey=/etc/nats-certs/form3/tls.key \
    --tlscert=/etc/nats-certs/form3/tls.crt \
    --tlsca=/etc/nats-certs/form3/ca.crt \
    --filter '' \
    --ack explicit \
    --pull \
    --deliver all \
    --max-deliver=-1 \
    --sample 100 \
    --replay instant \
    --max-pending=0

# Create Push Consumer
kubectl exec --context=kind-kind -it deploy/nats-box -- nats con add CAFPSPAYMENTS CAFPSPAYMENTSPUSHCONSUMER \
    --tlskey=/etc/nats-certs/ca/tls.key \
    --tlscert=/etc/nats-certs/ca/tls.crt \
    --tlsca=/etc/nats-certs/ca/ca.crt \
    --filter '' \
    --ack none \
    --target CA.FPS.paymentsstreamresult \
    --deliver last \
    --replay instant \
    --heartbeat 1m \
    --flow-control
