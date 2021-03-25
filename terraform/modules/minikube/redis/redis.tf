resource "helm_release" "redis" {
  name = "redis"
  repository = var.helm_repository
  chart = "redis"
}