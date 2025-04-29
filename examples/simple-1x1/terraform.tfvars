cluster_scheme = [
  {
    name = "minio1",
    online_volumes = ["data1","data2"]
    offline_volumes = [ ]
  }
]

volumes_def = "/mnt/data{1...2}"
