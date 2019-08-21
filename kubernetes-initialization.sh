#!/bin/bash

export ENVIRONMENT="production"
export CLUSTER_NAME="useast1.dev.dappest.co"

export HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Set up namespace
kubectl create -f "${HOME_DIR}/kubernetes/namespace/namespace-${ENVIRONMENT}.json"
kubectl config set-context ${ENVIRONMENT} --namespace=${ENVIRONMENT} --cluster=${CLUSTER_NAME} --user=${CLUSTER_NAME}
kubectl config use-context ${ENVIRONMENT}

# Create dockerhub secret in environment
kubectl apply -f "${HOME_DIR}/kubernetes/credentials/dappest-docker-cred.yaml"

# Create IAM access key secret for cert-manager
kubectl create secret generic acme-route53 --namespace=${ENVIRONMENT} --from-file="${HOME_DIR}/kubernetes/credentials/acme-route53-access-key"

# Set up helm
kubectl create -f "${HOME_DIR}/kubernetes/tiller/rbac-config.yaml"
helm init --service-account tiller
sleep 60

# Install ingress controller via helm
helm install "${HOME_DIR}/kubernetes/charts/nginx-ingress" --name nginx-dev --set rbac.create=true -f "${HOME_DIR}/kubernetes/charts/nginx-ingress/values.yaml" --namespace ${ENVIRONMENT}

# Install cert-manager via helm
# NEED TO TEST
helm install --name cert-manager --namespace ${ENVIRONMENT} --set ingressShim.defaultIssuerName=letsencrypt-prod --set ingressShim.defaultIssuerKind=ClusterIssuer stable/cert-manager

# Install RabbitMQ
helm install "${HOME_DIR}/kubernetes/charts/rabbitmq-ha" --name rabbitmq-dev -f "${HOME_DIR}/kubernetes/charts/rabbitmq-ha/values.yaml" --namespace ${ENVIRONMENT}

# Create cluster issuer and certificate
# NEED TO TEST
kubectl create -f "${HOME_DIR}/kubernetes/cluster-issuer.yaml"
kubectl create -f "${HOME_DIR}/kubernetes/ingress/certificate.yaml"

# Create db external service
kubectl apply -f "${HOME_DIR}/kubernetes/deployments/postgres-service.yaml"

# Create service and deployment
kubectl apply -f "${HOME_DIR}/kubernetes/deployments/dappest-api-service.yaml"
kubectl apply -f "${HOME_DIR}/kubernetes/deployments/dappest-api-deployment.yaml"

# Create ingress rules
kubectl apply -f "${HOME_DIR}/kubernetes/ingress/ingress.yaml"
