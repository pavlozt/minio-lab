# variables.tf
variable "cluster_scheme" {
  description = "Minio Cluster scheme"
  type = list(object({
    name    = string
    volumes = number
  }))
}

variable "vol_def" {
  type        = string
  description = "Minio Volumes Definition String"
}

variable "erasure_set_drive_count" {
  type        = string
  description = "Setting MINIO_ERASURE_SET_DRIVE_COUNT"
  default     = ""
}


variable "network_name" {
  description = "Docker network name"
  type        = string
  default     = "minio_network"
}

variable "minio_image" {
  description = "minio image name"
  type        = string
  default     = "minio/minio:latest"
}
variable "minio_client_image" {
  description = "minio client image name"
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