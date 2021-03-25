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

provider "helm" {
  alias = "infra_helm"
  kubernetes {
    config_path = local.kube_config
  }
}

//---> Deploy App
module "deploy_application" {
  source = "../modules/minikube/pizza_express"
  providers = {
    helm = helm.infra_helm
  }
  helm_repository = "../../helm/charts"
  depends_on = [null_resource.copy_minikube_config]
}