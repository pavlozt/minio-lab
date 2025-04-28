# main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.4.0" # tested version
    }
  }
}

provider "docker" {}
