# Native Nginx Kube ingress on GCP

To demo how to use the Native Kube ingress on GCP to expose several port behind a single IP.

# Hello World flask APP

To be use as dummy docker answering a "hello World"

## Build

PS C:\Code\SimpleFlask> docker build -t simpleflask .
PS C:\Code\SimpleFlask> docker tag 0fb359f3cfbe charly37/simpleflask:1
PS C:\Code\SimpleFlask> docker push charly37/simpleflask:1

## Use

PS C:\Code\SimpleFlask> docker run -p 8077:8080 simpleflask
 * Serving Flask app "main" (lazy loading)
 * Environment: production
   WARNING: Do not use the development server in a production environment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
172.17.0.1 - - [05/Aug/2018 20:17:48] "GET / HTTP/1.1" 200 -

Then you should be able to curl on port 8077 and get a "hello world" answer

# run for DEV ENV
docker run -it --entrypoint "bash" -v C:\Code\SimpleFlask\:/code charly37/simpleflask

# Kube Cluster on GCP setup

Explain how to deploy 2 POD of the dummy app to demo the exposure of 2 services with 1 IP. The following operation can be done in the container detail previously if you start it in DEV ENV.

## log in gcloud
gcloud auth login

## Create Kube cluster on GKE
Create the cluster in UI or
gcloud container clusters create cluster-1 --project testfwtf --zone=us-central1-a --machine-type=n1-standard-2 --num-nodes=2

##get cred for kube cluster
gcloud container clusters get-credentials cluster-1 --region us-central1-a --project testfwtf

Verify with
kubectl get pod --all-namespaces


#Create the 2 deployments (each contains 1 single web server)
kubectl create -f ./Deployment1.yaml
kubectl create -f ./Deployment2.yaml

#create the 2 services
kubectl create -f ./Service1.yaml
kubectl create -f ./Service2.yaml

#Verify by curling them (find the IP of one of a node on the cluster)
curl -X GET <IP>:30156
curl -X GET <IP>:30157
If it fails check the FW rules to open ports 30156 and 30157

# intall Native ingress framework
https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/index.md
If error "clusterroles.rbac.authorization.k8s.io "nginx-ingress-clusterrole" is forbidden" give your self more permission on the kubecluster with
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)

and verify that Nginx Ingress pods are here
kubectl get pod --all-namespaces | grep ingress
ingress-nginx   default-http-backend-7595f4d4c-ftq2c                  0/1       Pending   0          2m
ingress-nginx   nginx-ingress-controller-7484f87bcd-pvfwt             1/1       Running   3          1m

# Create Nginx ingress ressource for each service
kubectl create -f ./Ingress1.yaml
kubectl create -f ./Ingress2.yaml

This will create a Load balancer in GCP that you can see in the networking section under the "Network services"

Add the Lb Ip in your DNS config to match the route publish in the ingress
