#  Ready to interact container with minio client

resource "docker_container" "minio_client" {
  name       = "mc"
  entrypoint = ["tail", "-f", "/dev/null"] # infinite loop

  # rendered config from local host
  volumes {
    host_path      = abspath(local_file.mc_config.filename)
    container_path = "/root/.mc/config.json"
    read_only      = true
  }

  env = [
    "MINIO_ROOT_USER=admin",
    "MINIO_ROOT_PASSWORD=${var.admin_password}",
    "MINIO_VOLUMES=${var.vol_def}"
  ]
  networks_advanced {
    name = docker_network.minio_network.name
  }
  image = var.minio_client_image
}


resource "local_file" "mc_config" {
  content = templatefile("${path.module}/templates/mc_config.json.tpl", {
    main_endpoint = "http://minio1:9000"
    access_key    = "admin"
    secret_key    = var.admin_password
    nodes = [for name, container in docker_container.minio_node : {
      name = name
      url  = "http://${name}:9000"
      last = name == keys(docker_container.minio_node)[length(docker_container.minio_node) - 1]
    }]
  })
  filename = "${path.module}/mc_config/config.json"
}
