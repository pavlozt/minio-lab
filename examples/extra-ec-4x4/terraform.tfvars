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
volumes_def = "http://minio{1...4}/mnt/data{1...4}"
erasure_set_drive_count = 8
storage_class_standard = "EC:4"
storage_class_rss = "EC:2"
