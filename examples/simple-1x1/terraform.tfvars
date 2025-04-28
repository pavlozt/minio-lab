cluster_scheme = [
  {
    name    = "minio1",
    volumes = 1
  }
]
vol_def = "/mnt/data1"

minio_image        = "minio/minio:RELEASE.2025-04-22T22-12-26Z"
minio_client_image = "minio/mc:RELEASE.2025-04-16T18-13-26Z"
