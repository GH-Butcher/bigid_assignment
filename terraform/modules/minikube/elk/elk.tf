resource "helm_release" "elk" {
  name = "elk"
  repository = var.helm_repository
  chart = "elk"
}