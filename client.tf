#  Ready to interact container with minio client

resource "docker_container" "minio_client" {
  count      = var.control_container ? 1 : 0
  name       = "mc"
  entrypoint = ["tail", "-f", "/dev/null"] # infinite loop

  # rendered config from local host
  volumes {
    host_path      = abspath(local_file.mc_config[0].filename)
    container_path = "/root/.mc/config.json"
    read_only      = true
  }

  env = [
    "MINIO_ROOT_USER=admin",
    "MINIO_ROOT_PASSWORD=${var.admin_password}",
    "MINIO_VOLUMES=${var.volumes_def}"
  ]
  networks_advanced {
    name = var.network_name
  }
  image = var.minio_client_image
}


resource "local_file" "mc_config" {
  count      = var.control_container ? 1 : 0
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
