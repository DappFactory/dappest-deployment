# Kubernetes

## Steps

1. Create dockerhub secret
    * ```kubectl create secret docker-registry dappest-docker-cred --docker-server=<your-registry-server> --docker-username=<your-name> --docker-password=<your-pword> --docker-email=<your-email>```
    * Set ```imagePullSecrets``` in ```spec``` field
2. Set up namespace
    * ```kubectl create -f namespace-dev.json```
    * ```kubectl config set-context dev --namespace=development --cluster=useast1.dev.dappest.co --user=useast1.dev.dappest.co```
    * ```kubectl config use-context dev```
2. Install ingress controller via helm
    * ```kubectl create -f rbac-config.yaml```
    * ```helm init --service-acount tiller```
    * ```helm install stable/nginx-ingress --name nginx-dev --set rbac.create=true -f values.yaml --namespace development```
3. Add ingress rule sets
    * ```kubectl create -f ingress.yaml```
4. Deployment

## Notes
* Create the service before deployment
* https://medium.com/google-cloud/kubernetes-best-practices-8d5cd03446e2
* LoadBalancer is L4, Ingress is L7