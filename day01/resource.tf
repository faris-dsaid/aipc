data "digitalocean_ssh_key" "aipc" {
  name = "aipc"
}

output aipc_ssh_key{
    value = data.digitalocean_ssh_key.aipc.public_key
}

output aipc_ssh_fingerprint{
    value = data.digitalocean_ssh_key.aipc.fingerprint
}

resource local_file aipc_public_key{
    filename = "aipc.pub"
    content = data.digitalocean_ssh_key.aipc.public_key
    file_permission = "0644"
}

data "docker_image" "dov-bear" {
  name = "chukmunnlee/dov-bear:v2"
}

resource docker_container dov-bear-container {
    count = length(var.ports)
    name = "dov-bear-${count.index}"
    image = data.docker_image.dov-bear.id
    env = [
        "INSTANCE_NAME=myapp-${count.index}",
        "INSTANCE_HASH=${count.index}"
    ]
    ports {
        internal = 3000
        external = var.ports[count.index]
    }
}

resource docker_container dov-bear-unique {
    for_each = var.containers
    name = each.key
    image = data.docker_image.dov-bear.id
    env = [
        "INSTANCE_NAME=myapp-${each.key}",
        "INSTANCE_HASH=${each.key}"
    ]
    ports {
        internal = 3000
        external = each.value.external_port
    }
}

resource local_file container_name{
    content = join(", ", [for c in docker_container.dov-bear-container: c.name])
    filename = "container-names.txt"
    file_permission = "0644"
}

output container-names {
    value = [for c in docker_container.dov-bear-container: c.name]
}


output dov-bear-md5 {
    value = data.docker_image.dov-bear.repo_digest
    description = "SHA of the image"
}


# resource "digitalocean_droplet" "example" {
#   image    = "ubuntu-18-04-x64"
#   name     = "example-1"
#   region   = "nyc2"
#   size     = "s-1vcpu-1gb"
#   ssh_keys = [data.digitalocean_ssh_key.example.id]
# }

resource digitalocean_droplet nginx {
    name = "nginx"
    image = var.DO_image
    size = var.DO_size
    region = var.DO_region
    ssh_keys = [data.digitalocean_ssh_key.aipc.id]
    connection{
        type = "ssh"
        user = "root"
        private_key = file(var.DO_private_key)
        host = self.ipv4_address
    }
    provisioner remote-exec{
        inline = [
            "apt update",
            "apt install nginx -y",
            "systemctl enable nginx",
            "systemctl start nginx"
        ]
    }
}
resource local_file root_at_nginx {
    content = ""
    filename = "root@${digitalocean_droplet.nginx.ipv4_address}"
}
output nginx_ip {
    value = digitalocean_droplet.nginx.ipv4_address
}