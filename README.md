# BigID Home assignment
The project consist of 3 stages:

`Stage 1:  Build, Test, Push to the Docker Hub an artifact`

`Stage 2:  Deploy infra: Ingress Controller, Ingress Resource, ELK stack, Redis and Filebeat`

`Stage 3:  Deploy an artifact into the new infra`

# In order to perform successfull project testing following requirements must be met:
`1. minikube configuration`
```shell
minikube start
minikube stop
VBoxManage modifyvm "minikube" --cpus 4 --memory 8192
minikube start --vm-driver=virtualbox
```
`2. /etc/hosts update with values provided by terraform infra stage`
```shell
111.111.11.111 pizza-express.com
222.222.22.222 pizza-kibana.com
```
