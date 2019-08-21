profile = "dappest-dev"
region = "us-east-1"

cluster_name_prefix = "useast1"

kops_conf_template_name = "dappest-dev-kops"

master_count = 1

vpc_remote_state_key = "dappest-terraform/terraform/stacks/kops-base/test.tfstate"
vpc_remote_state_bucket = "cluster.dev.dappest.co"

kops_base_remote_state_key = "dappest-terraform/terraform/stacks/kops-base/test.tfstate"
kops_base_remote_state_bucket = "cluster.dev.dappest.co"