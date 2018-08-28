# Native Nginx Kube ingress on GCP 

 
 

To demo how to use the Native Kube ingress on GCP to expose several ports behind a single IP. 

 
 

# Hello World flask APP 

 
 

To be use as dummy docker answering a "hello World" 

 
 

## Build 

You can build and publish the docker image with:  

``` 

docker build -t simpleflask . 

docker tag 0fb359f3cfbe charly37/simpleflask:1 

docker push charly37/simpleflask:1 

``` 

## Use 

The docker image can be started with: 

``` 

PS C:\Code\SimpleFlask> docker run -p 8077:8080 simpleflask 

* Serving Flask app "main" (lazy loading) 

* Environment: production 

WARNING: Do not use the development server in a production environment. 

Use a production WSGI server instead. 

* Debug mode: off 

* Running on http://0.0.0.0:8080/ (Press CTRL+C to quit) 

172.17.0.1 - - [05/Aug/2018 20:17:48] "GET / HTTP/1.1" 200 - 

``` 

Then you should be able to curl on port 8077 and get a "hello world" answer 

 
 

# Run for DEV ENV 

docker run -it --entrypoint "bash" -v C:\Code\SimpleFlask\:/code charly37/simpleflask 

 
 

# Kube Cluster on GCP setup 

 
 

Explain how to deploy 2 POD of the dummy app to demo the exposure of 2 services with 1 IP. The following operation can be done in the container detail previously if you start it in DEV ENV. 

 
 

## Log in gcloud 

You can log on GCP with the gcloud command install on the docker ENV. 

``` 

gcloud auth login 

``` 

 
 

## Create Kube cluster on GKE 

Create the cluster in UI or 

``` 

gcloud container clusters create cluster-1 --project testfwtf --zone=us-central1-a --machine-type=n1-standard-2 --num-nodes=2 

``` 

 
 

## Get cred for Kube cluster 

Get the credential of the cluster with 

``` 

gcloud container clusters get-credentials cluster-1 --region us-central1-a --project testfwtf 

``` 

Verify with 

``` 

kubectl get pod --all-namespaces 

``` 

 
 

# Create the 2 deployments (each contains 1 single web server) 

Create the 2 deployments (one per Webserver) with: 

``` 

kubectl create -f ./Deployment1.yaml 

kubectl create -f ./Deployment2.yaml 

``` 

 
 

# Create the 2 services 

Create the 2 associated services with: 

``` 

kubectl create -f ./Service1.yaml 

kubectl create -f ./Service2.yaml 

``` 

# Verify by pinging them (find the IP of one of the cluster’s nodes) 

You can ping them with curl 

``` 

curl -X GET <IP>:30156 

curl -X GET <IP>:30157 

``` 

If it fails, check the FW rules to open ports 30156 and 30157 

 
 

# Install Native ingress framework 

https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/index.md 

If error "clusterroles.rbac.authorization.k8s.io "nginx-ingress-clusterrole" is forbidden" give yourself more permission on the kubecluster with:  

``` 

kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account) 

``` 

and verify that Nginx Ingress pods are here with:  

``` 

kubectl get pod --all-namespaces | grep ingress 

ingress-nginx default-http-backend-7595f4d4c-ftq2c 0/1 Pending 0 2m 

ingress-nginx nginx-ingress-controller-7484f87bcd-pvfwt 1/1 Running 3 1m 

``` 

 
 

# Create Nginx ingress resources for each service 

You can now create the 2 associated Ingress resources with: 

``` 

kubectl create -f ./Ingress1.yaml 

kubectl create -f ./Ingress2.yaml 

``` 

This will create a Load balancer in GCP that you can see in the networking section under the "Network services" 

 
 

# Publish the routes on your DNS 

The 2 ingress contains 2 URL that need to be publish on your DNS server. 

Add the Lb Ip in your DNS config to match the route publish in the ingress 

 
 

# Target clusters 

you can now target the 2 pods with their respective routes: 

``` 

http://svc1.djynet.xyz/ 

http://svc2.djynet.xyz/ 

``` 

You should get a "hello world" for both.  

 
 

# Make it private 

The main point of using this solution over the native GCP load balancer is that you can make all the elements private (not accessible from internet). 

 
 

## Private Kube cluster 

The Kubernetes cluster made in the first step is a public one (all VM have public IP and are thus expose on internet) but it can be made private by adding the following flag at cluster creation time:  

``` 

--private-cluster --master-ipv4-cidr XXXXXXXXX --enable-ip-alias 

``` 

More info here https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters 

## Private Load balancer 

The Nginx ingress controller will create a TCP load balancer which is public by default but can be made private by adding the following annotation on the Kube Load balancer pod 

''' 

cloud.google.com/load-balancer-type: "Internal" 

''' 

More info here https://cloud.google.com/kubernetes-engine/docs/how-to/internal-load-balancing 

 