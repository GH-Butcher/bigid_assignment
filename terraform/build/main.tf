//--> Build Run, Test, Push the Image

module "image_handler" {
  source = "../modules/build"
  app_location = "${path.module}/../../pizza-express"
  container_name = "pizza_test"
  docker_image_name = "gbutchers/pizza-express"
}