variable DO_token {
    type = string 
    sensitive = true
}
variable DO_private_key {
    type = string 
    sensitive = true
}
variable DO_image {
    type = string
    default = "ubuntu-20-04-x64"
}
variable DO_region {
    type = string
    default = "sgp1"
}
variable DO_size {
    type = string
    default = "s-1vcpu-1gb"
}

variable docker_host_ip {
  type = string
}

variable app_instances {
  type = number
  default = 4
}
