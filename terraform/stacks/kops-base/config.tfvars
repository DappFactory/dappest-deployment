profile = "dappest-dev"
region = "us-east-1"

subdomain_hosted_zone = "dev.dappest.co"

tags = {
  ManagedWith    = "terraform"
  KeepUntil      = "permanent"
  Environment    = "dev"
  tfstate-bucket = "terraform-dappest-dev"
  tfstate-key    = "dappest-terraform/terraform/stacks/kops-base/test.tfstate"
}