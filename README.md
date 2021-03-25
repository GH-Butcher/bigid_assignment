# BigID Home assignment
The project consist of 3 stages:

`Stage 1:  Build, Test, Push to the Docker Hub an artifact`

`Stage 2:  Deploy infra: Ingress Controller, Ingress Resource, ELK stack, Redis and Filebeat`

`Stage 3:  Deploy an artifact into the new infra`

# Deployment flow
Use scripts in `test` directory in order to test deployment process

Usage examples:

`1. build stage: build, test and push artifact to the Docker Hub`
```shell
#--> create/update
/test/build.sh false
#--> destroy
/test/build.sh true
```
`2. infra stage: create Ingress Controller, Ingress Resource, ELK stack, Redis and Filebeat`
```shell
#--> create/update
/test/create_infra.sh false
#--> destroy
/test/create_infra.sh true
```
`3. deployment stage: Deploy an artifact into the new infra`
```shell
#--> create/update
/test/deploy_pizza.sh false
#--> destroy -> not required in this case
/test/deploy_pizza.sh true
```


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
