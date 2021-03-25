output "important_notification" {
  value = "\n[ADD]:[FOR]:[TESTING] Please add following lines to the '/etc/hosts' file:\n\t${module.ingress_nginx.minikube_ip_address} pizza-express.com\n\t${module.ingress_nginx.minikube_ip_address} pizza-kibana.com"
}
