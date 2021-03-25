resource "null_resource" "run_unit_tests" {
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = "cd \"${var.app_location}\";npm test"
  }
}

resource "null_resource" "build_docker" {
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = "cd \"${var.app_location}\";docker build -t \"${var.docker_image_name}\" ."
  }
  depends_on = [null_resource.run_unit_tests]
}

resource "null_resource" "run_docker" {
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = "docker run --name \"${var.container_name}\" --rm -d -p 8081:3000 -e REDIS_HOST=localhost -e REDIS_PORT=6379 \"${var.docker_image_name}\""
  }
  depends_on = [null_resource.build_docker]
}

resource "null_resource" "test_docker_and_remove" {
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = "sleep 2;curl -I http://localhost:8081;docker stop \"${var.container_name}\""
  }
  depends_on = [null_resource.build_docker]
}

resource "null_resource" "push_docker" {
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = "docker push \"${var.docker_image_name}\""
  }
  depends_on = [null_resource.test_docker_and_remove]
}