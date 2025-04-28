output "node_access_urls" {
  value = {
    for name, container in docker_container.minio_node :
    name => "http://localhost:${container.ports[0].external}"
  }
}

output "admin_login" {
  value = "admin"
}
output "admin_password" {
  value = var.admin_password
}
output "console_command_instruction" {
  value = "# Run minio console in container:\ndocker exec -it mc sh\nmc admin info myminio\n"
}
