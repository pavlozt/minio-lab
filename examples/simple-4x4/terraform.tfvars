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
volumes_def = "http://minio{1...2}/mnt/data{1...4} http://minio{3...4}/mnt/data{1...4}"

