terraform {
  required_providers {
    aws = "~> 3.10"
    random = "~> 2.2"
    null = "~> 2.1"
    template = "~> 2.1"
    helm = "~> 1.2"
    kubernetes = "~> 1.13"
    archive = "~> 1.3"
  }
}

locals {
  kube_config = "${path.module}/../modules/minikube/kube_config/config"
}

#---> [PREPARATION STEPS] Copy local configuration to the project
resource "null_resource" "copy_minikube_config" {
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = "cp ~/.kube/config ${path.module}/../modules/minikube/kube_config"
  }
}

provider "kubernetes" {
  alias = "infra_kubernetes"
  config_path = local.kube_config
}

provider "helm" {
  alias = "infra_helm"
  kubernetes {
    config_path = local.kube_config
  }
}

//--> Deploy Ingress Controller and Ingress Resource
module "ingress_nginx" {
  providers = {
    helm = helm.infra_helm
  }
  source = "../modules/minikube/ingress"
  kube_config = local.kube_config
  helm_repository = "../../helm/charts"

  depends_on = [
    null_resource.copy_minikube_config]
}

//---> Deploy Redis
module "redis" {
  source = "../modules/minikube/redis"
  providers = {
    helm = helm.infra_helm
  }
  helm_repository = "../../helm/charts"
}

//---> Deploy ELK Stack - Elasticsearch + Kibana
module "elk" {
  source = "../modules/minikube/elk"
  providers = {
    helm = helm.infra_helm
  }
  helm_repository = "../../helm/charts"
}

//---> Deploy Filebeat - kubernetes logs harvester
module "filebeat" {
  source = "../modules/minikube/filebeat"
  providers = {
    helm = helm.infra_helm
  }
  helm_repository = "../../helm/charts"
}