variable DO_token {
    type = string
    sensitive = true
}

variable DO_image {
    type = string
    default = "ubuntu-20-04-x64"
}

variable DO_size {
    type = string
    default = "s-4vcpu-8gb"
}

variable DO_region {
    type = string
    default = "sgp1"
}

variable DO_private_key {
    type = string
    default = "/home/fred/.ssh/id_rsa"
}

