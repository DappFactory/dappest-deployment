#!/bin/bash

export ENVIRONMENT="development"

# terraform variables
export HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# kops config
export BUCKET_NAME="cluster.dev.dappest.co"
export KOPS_CLUSTER_NAME="useast1.dev.dappest.co"

# kops state
export KOPS_STATE_STORE="s3://$BUCKET_NAME"

# kops base
export KOPS_BASE_STACK_DIR="${HOME_DIR}/terraform/stacks/kops-base"
export KOPS_BASE_TF_CONFIG="${KOPS_BASE_STACK_DIR}/config.tfvars"
export KOPS_BASE_CONFIG="${KOPS_BASE_STACK_DIR}/config.conf"

# Delete k8s resources
#kubectl -n ${ENVIRONMENT} delete pods,services,deployments --all

# Delete k8s cluster
kops delete cluster --name ${KOPS_CLUSTER_NAME} --state ${KOPS_STATE_STORE} --yes

# Delete terraform resources
cd ${KOPS_BASE_STACK_DIR}
terraform init -backend-config ${KOPS_BASE_CONFIG}
terraform destroy --var-file ${KOPS_BASE_TF_CONFIG} -auto-approve