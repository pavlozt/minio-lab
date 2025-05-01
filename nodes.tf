resource "docker_network" "minio_network" {
  name = var.network_name
}


resource "docker_volume" "node_volumes" {
  for_each = {
    for vol in flatten(
      [for node in var.cluster_scheme :
        # Two types of volume specifications are supported
        node.volumes != null
        ? [for i in range(1, node.volumes + 1) : {
          node_name = node.name
          vol_name  = "data${i}"
        }]
        : [for vol_name in concat(node.online_volumes, node.offline_volumes) : {
          node_name = node.name
          vol_name  = vol_name
        }]
      ]
    ) : "${vol.node_name}_${vol.vol_name}" => vol
  }
  name = "${each.value.node_name}_${each.value.vol_name}"
}

resource "docker_container" "minio_node" {
  for_each = { for idx, node in var.cluster_scheme : node.name => {
    node  = node
    index = idx
  } }

  name    = each.value.node.name
  image   = var.minio_image
  command = ["server", "--address",":9000", "--console-address", ":9001"]

  ports {
    internal = 9000
    external = var.base_ui_port + each.value.index * 2
  }

  ports {
    internal = 9001
    external = var.base_ui_port + each.value.index * 2 + 1
  }

  dynamic "volumes" {
    for_each = each.value.node.volumes != null ? [for i in range(1, each.value.node.volumes + 1) : "data${i}"] : each.value.node.online_volumes
    content {
      volume_name    = docker_volume.node_volumes["${each.value.node.name}_${volumes.value}"].name
      container_path = "/mnt/${volumes.value}"
    }
  }

  env = concat(
    [
      "MINIO_ROOT_USER=admin",
      "MINIO_ROOT_PASSWORD=${var.admin_password}",
      "MINIO_VOLUMES=${var.volumes_def}"
    ],
    var.erasure_set_drive_count != "" ? [
      "MINIO_ERASURE_SET_DRIVE_COUNT=${var.erasure_set_drive_count}"
    ] : [],
    var.storage_class_standard != "" ? [
      "MINIO_STORAGE_CLASS_STANDARD=${var.storage_class_standard}"
    ] : [],
    var.storage_class_rss != "" ? [
      "MINIO_STORAGE_CLASS_RRS=${var.storage_class_rss}"
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
