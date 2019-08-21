# kops-base

This stack creates a hosted zone for all k8s specific resources. It also 
creates a bucket to place the KOPS configuration in. (This is similar to 
the terraform remote bucket). 


## Usage

Example tfvars

```
main_zone = "dev-aws.dappest.co"
subdomain = "example"

tags = {
  ManagedWith    = "terraform"
  KeepUntil      = "permanent"
  Environment    = "examples"
  tfstate-bucket = "terraform-dappest-dev"
  tfstate-key    = "dappest-terraform/terraform/stacks/kops-base/examples/basic/example.tfstate"
}
```


## Hosted Zone 

Creating a hosted zone for all k8s resources is recommeded when creating a cluster ([https://kubernetes.io/docs/getting-started-guides/kops/](https://kubernetes.io/docs/getting-started-guides/kops/)).
The cluster name then becomes a subdomain in that hosted zone. 


An example hosted zone would be

```
k8s.dev.dappest.co
```


Then when creating a cluster _(not part of this stack)_, the cluster name can be

```
dev-cluster.k8s.dev.dappest.co
``` 


## Bucket

Simply stores the configuration of each cluster. By default, the name will be:
 
```
cluster.$HOSTED_ZONE
```

## Updates

Propose changes to this stack by pull request.
