cluster_scheme = [
  {
    name = "minio1",
    volumes = 4
  },
  {
    name = "minio2"
    volumes = 4
  },
  {
    name = "minio3"
    volumes = 4
  },
  {
    name = "minio4"
    volumes = 4
  },

]
vol_def = "http://minio{1...4}/mnt/data{1...4}"
erasure_set_drive_count = 8

minio_image        = "minio/minio:RELEASE.2025-04-22T22-12-26Z"
minio_client_image = "minio/mc:RELEASE.2025-04-16T18-13-26Z"
