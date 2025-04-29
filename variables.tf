variable "cluster_scheme" {
  description = "Minio Cluster scheme"
  type = list(object({
    name            = string
    online_volumes  = optional(list(string), [])
    offline_volumes = optional(list(string), [])
    volumes         = optional(number)
  }))
  validation {
    condition = alltrue([
      for node in var.cluster_scheme :
      (node.volumes != null && length(node.online_volumes) == 0 && length(node.offline_volumes) == 0) ||
      (node.volumes == null && (length(node.online_volumes) + length(node.offline_volumes) > 0))
    ])
    error_message = "Each node must specify either 'volumes' or at least one of 'online_volumes'/'offline_volumes', but not both."
  }
}

variable "volumes_def" {
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
