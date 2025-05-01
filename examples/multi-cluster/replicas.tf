module "src_cluster" {
  source = "git::https://github.com/pavlozt/minio-lab//?ref=0.0.1"
  cluster_scheme = [
    {
      name    = "minio1",
      volumes = 4
    },
    {
      name    = "minio2"
      volumes = 4
    }
  ]
  volumes_def       = "http://minio{1...2}/mnt/data{1...4}"
  base_ui_port      = 9000
  create_network    = false
  control_container = false
  network_name      = "minio_network"
}

module "dst_cluster" {
  source = "git::https://github.com/pavlozt/minio-lab//?ref=0.0.1"
  cluster_scheme = [
    {
      name    = "loc2-minio1",
      volumes = 2
    },
    {
      name    = "loc2-minio2",
      volumes = 2
    }

  ]
  volumes_def       = "http://loc2-minio{1...2}/mnt/data{1...2}"
  base_ui_port      = 9100
  create_network    = false
  control_container = false
  network_name      = "minio_network"
}
