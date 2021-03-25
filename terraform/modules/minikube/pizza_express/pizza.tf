resource "helm_release" "pizza_express" {
  name = "pizzaexpress"
  repository = var.helm_repository
  chart = "pizzaexpress"
}