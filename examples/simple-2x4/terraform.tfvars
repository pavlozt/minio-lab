cluster_scheme = [
  {
    name = "minio1",
    volumes = 4
  },
  {
    name = "minio2",
    volumes = 4
  },
]

volumes_def = "http://minio{1...2}/mnt/data{1...4}"

minio_image        = "minio/minio:RELEASE.2025-04-22T22-12-26Z"
minio_client_image = "minio/mc:RELEASE.2025-04-16T18-13-26Z"
