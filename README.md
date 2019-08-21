# dappest-terraform

## Notes
*  ```terraform init``` does not create an S3 bucket for the backend
    * Need to manually create S3 to store terraform and kops state
* AWS credentials are inherited from parent modules
    * Only specify AWS credentials in top-level ```main.tf```
    * Do not specify AWS credentials in any child modules
* Specify ```--state=s3://<bucket>``` when using kops to edit or update cluster
* Must add ```kubeAPIServer: authorizationRbacSuperUser: admin``` is ```authorization``` set to ```rbac```
   
 
## Steps
 1. Initialize kops-base from ```kops-base``` directory.
    * ```terraform init -backend-config config.conf -reconfigure -upgrade .```
 
 2. Create terraform plan.
    * ```terraform plan -var-file config.tfvars -out plan.out .```
    
 3. Apply terraform plan (create resources).
    * ```terraform apply plan.out```
 4. Initialize kops-template from ```kops-template``` directory.
    * ```terraform init```
 5. Create terraform plan from ```kops-template``` directory.
    * ```terraform plan -out plan.out -var-file config.tfvars .```
 6. Apply terraform plan to create ```kops.config```.
    * ```terraform apply plan.out```
 7. Create cluster using ```kops```.
    * ```kops create cluster --zones us-east-1a --state s3://cluster.dev.dappest.co --name <BUCKET_NAME>```
 8. Remove the default instance groups.
    * ```kops delete ig master-us-east-1a --state s3://cluster.dev.dappest.co --name <BUCKET_NAME> --yes```
    * ```kops delete ig nodes --state s3://cluster.dev.dappest.co --name <BUCKET_NAME> --yes```
 9. Update kops configuration.
    * ```kops replace --state s3://cluster.dev.dappest.co --name <BUCKET_NAME> -f dappest-dev-kops.config --force```
 10. Deploy kubernetes cluster.
    * ```kops update cluster --state s3://cluster.dev.dappest.co --name <BUCKET_NAME> --yes```
    
    
## Issues
* Understand why the period at end of hosted_zone.name causes S3 creation to fail.
* Running ```terraform destroy``` on a non-empty S3 bucket.
* When updating cluster with kops, need to specify ```--cloudonly``` until k8s API server configuration is set up properly


## Questions
* Why separate kops-base and VPC remote state?