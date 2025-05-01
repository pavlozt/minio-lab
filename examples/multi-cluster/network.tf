resource "docker_network" "minio_network" {
  name = var.network_name
}