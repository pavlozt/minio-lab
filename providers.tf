terraform {
  required_version = ">= 0.14.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.4.0" # tested version
    }
  }
}

provider "docker" {}
