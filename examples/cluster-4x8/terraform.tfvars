cluster_scheme = [
  {
    name = "minio1",
    volumes = 8
  },
  {
    name = "minio2"
    volumes = 8
  },
  {
    name = "minio3"
    volumes = 8
  },
  {
    name = "minio4"
    volumes = 8
  }
]
volumes_def = "http://minio{1...4}/mnt/data{1...8}"


