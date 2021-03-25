resource "helm_release" "nginx_ingress" {
  name = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  wait = false
  //---> minikube doesnt create External IP and stuck the process
}

data "external" "get_minikube_ip_address" {
  program = [
    "node",
    "${path.module}/script/get_minikube_ip.js"]
  depends_on = [
    helm_release.nginx_ingress]
}


resource "null_resource" "patch_ingress_external_ip_minikube" {
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    environment = {
      KUBECONFIG = var.kube_config
    }
    command = "kubectl patch svc ingress-nginx-controller -p '{\"spec\":{\"externalTrafficPolicy\":\"Local\",\"externalIPs\":[\"${data.external.get_minikube_ip_address.result["minikube_ip"]}\"]}}'"
  }
  depends_on = [
    data.external.get_minikube_ip_address]
}

resource "null_resource" "delete_ingress_validating_webhook_configuration" {

  provisioner "local-exec" {
    environment = {
      KUBECONFIG = var.kube_config
    }
    command = "kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission; echo ''"
  }
  depends_on = [
    null_resource.patch_ingress_external_ip_minikube]
}

//---> Deploy Ingress Resource
resource "helm_release" "ingress_resource" {
  name = "pizzaingress"
  repository = var.helm_repository
  chart = "pizzaingress"
}