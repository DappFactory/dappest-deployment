#!/bin/bash

# terraform variables
export HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export KOPS_BASE_STACK_DIR="${HOME_DIR}/terraform/stacks/kops-base"
export KOPS_TEMPLATE_STACK_DIR="${HOME_DIR}/terraform/stacks/kops-template"

# kops variables
export AWS_PROFILE=dappest-dev
export BUCKET_NAME="cluster.dev.dappest.co"
export CLUSTER_NAME="useast1.dev.dappest.co"
export KOPS_CONFIG_FILE="${HOME_DIR}/terraform/stacks/kops-template/dappest-dev-kops.config"

# kops state
export KOPS_STATE_STORE="s3://$BUCKET_NAME"

# TODO: remove all tfstate files

# Initialize kops-base
terraform init -backend-config "${KOPS_BASE_STACK_DIR}/config.conf" -reconfigure -upgrade ${KOPS_BASE_STACK_DIR}
terraform plan -var-file "${KOPS_BASE_STACK_DIR}/config.tfvars" -out "${KOPS_BASE_STACK_DIR}/plan.out" ${KOPS_BASE_STACK_DIR}
terraform apply "${KOPS_BASE_STACK_DIR}/plan.out"

# Initialize kops template
cd ${KOPS_TEMPLATE_STACK_DIR}
terraform init
terraform plan -out "${KOPS_TEMPLATE_STACK_DIR}/plan.out" -var-file "${KOPS_TEMPLATE_STACK_DIR}/config.tfvars" ${KOPS_TEMPLATE_STACK_DIR}
terraform apply "${KOPS_TEMPLATE_STACK_DIR}/plan.out"

# Create cluster
kops create cluster --zones us-east-1a --name ${CLUSTER_NAME}

# Remove the default instance groups
kops delete ig master-us-east-1a --name ${CLUSTER_NAME} --yes
kops delete ig nodes --name ${CLUSTER_NAME} --yes

# Update the kops configuration
kops replace --name ${CLUSTER_NAME} -f ${KOPS_CONFIG_FILE} --force

# Deploy
kops update cluster --name ${CLUSTER_NAME} --yes