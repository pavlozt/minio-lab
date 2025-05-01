variable "network_name" {
  description = "Docker network name"
  type        = string
  default     = "minio_network"
}

variable "minio_image" {
  description = "Minio image name"
  type        = string
  default     = "minio/minio:latest"
}
variable "minio_client_image" {
  description = "Minio client image name"
  type        = string
  default     = "minio/mc:latest"
}

variable "admin_password" {
  description = "admin password"
  type        = string
  default     = "adminadmin"
}

variable "base_ui_port" {
  description = "base ui port"
  type        = number
  default     = 9000
}

