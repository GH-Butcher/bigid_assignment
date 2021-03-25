//--> Deploy Filebeat
resource "helm_release" "filebeat" {
  name = "filebeat"
  repository = var.helm_repository
  chart = "filebeat"
}