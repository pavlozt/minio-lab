# MinIO Lab

A testing environment for rapid experimentation with tuning and verifying the fault tolerance of MinIO clusters.
All implemented using Docker and Terraform.

## Overview

This lab enables quick validation of MinIO cluster configurations through infrastructure-as-code provisioning. The Terraform-based setup allows simulating real-world failure scenarios to verify cluster resilience.

## Demo session

![Demo sessions](assets/screencast.gif)

## Configuration

1. Create/modify `terraform.tfvars` to define cluster topology.
   cluster_scheme is the primary configuration map:
   ```hcl
    cluster_scheme = [
      {
        name = "minio1",
        volumes = 4
      },
      {
        name = "minio2"
        volumes = 4
      },
    ]
   ```

1. `vol_def` represent `MINIO_VOLUMES` variable:
   ```hcl
   volumes_def = "http://minio{1...2}/mnt/data{1...4}"
   ```

1. Other variables typically require minimal adjustments. For example, you can use a specific version of MinIO.
   ```hcl
   minio_image = "minio/minio:RELEASE.2025-04-22T22-12-26Z"
   ````
## Start up

Just run `terraform init` and `terraform apply`. These commands interact with the Docker daemon and create the necessary objects.

A typical output will indicate which ports to use to access the containers, along with passwords and instructions.
After this, you can go to the web interface on the first node using the URL: [http://localhost:9001](http://localhost:9001).

The environment includes a MinIO Client (mc) container for cluster management:
```
# Access client container
docker exec -it mc sh

# Example commands
mc admin info myminio
mc ls -r -versions myminio
```


## Example Configurations

See the ready-made examples in the [examples/](examples/) directory. The `terraform.tfvars` file must be copied to the root directory of the project

## Failure Simulation Scenarios

### Server or network failure
```
docker stop minio2  # Stop specific node
```

### Disk Failure

In this situation, a different definition of `cluster_scheme` is used.

```hcl
cluster_scheme = [
  {
    name = "minio1",
    online_volumes = ["data1","data2"]
    offline_volumes = [ ]
  }
]
```

Move volume to offline_volumes section:

```hcl
cluster_scheme = [
  {
    name = "minio1",
    online_volumes = ["data1"]
    offline_volumes = ["data2"]
  }
]
```
then run `terraform apply`.
