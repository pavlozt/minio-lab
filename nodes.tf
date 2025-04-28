resource "docker_network" "minio_network" {
  name = var.network_name
}

resource "docker_volume" "node_volumes" {
  for_each = {
    for vol in flatten([
      for node in var.cluster_scheme : [
        for i in range(node.volumes) : "${node.name}_data${i + 1}"
      ]
    ]) : vol => vol
  }

  name = each.value
}

resource "docker_container" "minio_node" {
  for_each = { for idx, node in var.cluster_scheme : node.name => {
    node  = node
    index = idx
  } }

  name    = each.value.node.name
  image   = var.minio_image
  command = ["server", "--console-address", ":9001"]

  ports {
    internal = 9000
    external = var.base_ui_port + each.value.index * 2
  }

  ports {
    internal = 9001
    external = var.base_ui_port + each.value.index * 2 + 1
  }

  dynamic "volumes" {
    for_each = range(each.value.node.volumes)
    content {
      volume_name    = docker_volume.node_volumes["${each.value.node.name}_data${volumes.key + 1}"].name
      container_path = "/mnt/data${volumes.key + 1}"
    }
  }

  env = concat(
    [
      "MINIO_ROOT_USER=admin",
      "MINIO_ROOT_PASSWORD=${var.admin_password}",
      "MINIO_VOLUMES=${var.vol_def}"
    ],
    var.erasure_set_drive_count != "" ? [
      "MINIO_ERASURE_SET_DRIVE_COUNT=${var.erasure_set_drive_count}"
    ] : []
  )

  networks_advanced {
    name = docker_network.minio_network.name
  }

  restart = "unless-stopped"

  healthcheck {
    test     = ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
    interval = "1s"
    timeout  = "5s"
    retries  = 3
  }
}