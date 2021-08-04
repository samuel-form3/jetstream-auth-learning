.PHONY: create-cluster
create-cluster:
	kind create cluster
	./install-cert-manager.sh

.PHONY: destroy-cluster
destroy-cluster:
	kind delete cluster

.PHONY: install-nats-with-cert-auth
install-nats-with-cert-auth:
	./install-nats-with-cert-auth.sh

.PHONY: install-nats-with-jwt-auth
install-nats-with-jwt-auth:
	./install-nats-with-jwt-auth.sh

.PHONY: generate-jwts
generate-jwts:
	./generate-jwts.sh

.PHONY: helm-dependencies
helm-dependencies:
	helm repo add nats https://nats-io.github.io/k8s/helm/charts/
	helm repo add jetstack https://charts.jetstack.io
	helm repo update
