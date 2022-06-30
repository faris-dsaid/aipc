variable DO_token {
    type = string
    sensitive = true
}

source digitalocean mydroplet {
    api_token    = var.DO_token
    image        = "ubuntu-20-04-x64"
    region       = "sgp1"
    size         = "s-1vcpu-1gb"
    ssh_username = "root"
    snapshot_name = "mynginx"
}

build {
  sources = ["source.digitalocean.mydroplet"]

  provisioner ansible {
    playbook_file = "playbook.yaml"
  }
}