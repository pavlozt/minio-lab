# MinIO Lab

A testing environment for rapid experimentation with tuning and verifying the fault tolerance of MinIO clusters.
All implemented using Docker and Terraform.

## Overview

This lab enables quick validation of MinIO cluster configurations through infrastructure-as-code provisioning. The Terraform-based setup allows simulating real-world failure scenarios to verify cluster resilience.

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
    vol_def = "http://minio{1...2}/mnt/data{1...4}"
   ```

1. Other variables typically require minimal adjustments.
```hcl
    minio_image        = "minio/minio:RELEASE.2025-04-22T22-12-26Z"
````
## Start up

Just run `terraform init` and `terraform apply`. These commands interact with the Docker daemon and create the necessary objects.

A typical output will indicate which ports to use to access the containers, along with passwords and instructions.

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

### Server failure
```
docker stop 2  # Stop specific node
```

### Disk Failure
1. Access target container:
```
docker exec -it minio2 /bin/sh
```
2. Simulate disk failure:
```
rm -rf /mnt/data3  # Remove specific disk(s)
```