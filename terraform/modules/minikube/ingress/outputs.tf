output "minikube_ip_address" {
  value = data.external.get_minikube_ip_address.result["minikube_ip"]
}