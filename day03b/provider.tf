terraform {
  required_version = "> 1.2"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.21.0"
    }
    hashicorp = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
    backend_s3 {
      // Only for validation
      skip_credentials_validation = true
      skip_metadata_api_check= true
      skip_region_validation = true
      endpoint = "sgp1.digitaloceanspaces.com"
      region = "sgp1"
      bucket = "myspace151"
      key = "aipc/terraform.tfstate"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "2.17.0"
    }
  }
}

provider "digitalocean" {
  token= var.DO_token
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}