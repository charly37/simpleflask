# Simple hello world flask app to test

PS C:\Code\SimpleFlask> docker run -p 8077:8080 simpleflask
 * Serving Flask app "main" (lazy loading)
 * Environment: production
   WARNING: Do not use the development server in a production environment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
172.17.0.1 - - [05/Aug/2018 20:17:48] "GET / HTTP/1.1" 200 -


Then you should be able to curl on port 8077 and get a "hello world" answer

# build
PS C:\Code\SimpleFlask> docker build -t simpleflask .
PS C:\Code\SimpleFlask> docker tag 0fb359f3cfbe charly37/simpleflask:1
PS C:\Code\SimpleFlask> docker push charly37/simpleflask:1

# run
docker run -it --entrypoint "bash" -v C:\Code\SimpleFlask\:/code charly37/simpleflask

#log in gcloud
gcloud auth login
#get cred for kube cluster
gcloud container clusters get-credentials cluster-1 --region us-central1-a --project testfwtf
#Verify with
kubectl get pod --all-namespaces
#Create the 2 pods (each contains 1 single web server)
kubectl create -f ./Deployment1.yaml
kubectl create -f ./Deployment2.yaml
#Verify by curling them (find the IP of the node on the mono node cluster)
curl -X GET 35.184.104.174:30156
curl -X GET 35.184.104.174:30157
If it fails check the FW rules to open ports 30156 and 30157

# intall Native ingress framework
https://github.com/kubernetes/ingress-nginx/blob/master/docs/deploy/index.md
If error "clusterroles.rbac.authorization.k8s.io "nginx-ingress-clusterrole" is forbidden" give your self more permission on the kubecluster with
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)

and verify that Nginx Ingress pods are here
[root@d7053ed1a8ff code]# kubectl get pod --all-namespaces | grep ingress
ingress-nginx   default-http-backend-7595f4d4c-ftq2c                  0/1       Pending   0          2m
ingress-nginx   nginx-ingress-controller-7484f87bcd-pvfwt             1/1       Running   3          1m

# Create Nginx ingress ressource for each service


