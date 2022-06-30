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
data "digitalocean_image" "nginx_image" {
  name = "mynginx"
}

resource digitalocean_droplet nginx {
    name = "nginx"
    image = data.digitalocean_image.nginx_image.id
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
output nginx_url {
    value = "code-${digitalocean_droplet.nginx.ipv4_address}.nip.io"
}
# You can terraform the local file  referencing inventory template file
# so that the ip address will appear accordingly in inventory as part of automation
resource local_file inventory_file {
    content = templatefile("./inventory.tpl", {
        nginx_ip = digitalocean_droplet.nginx.ipv4_address
    })
    filename = "../ansible/inventory.yaml"
    file_permission = "0444"
}

resource local_file code_server_conf_file {
    content = templatefile("./code-server.conf.tpl", {
        nginx_ip = digitalocean_droplet.nginx.ipv4_address
    })
    filename = "../ansible/code-server.conf"
    file_permission = "0444"
}

resource local_file code_server_service_file {
    content = templatefile("./code-server.service.tpl", {
        password_code_server = var.password_code_server
    })
    filename = "../ansible/code-server.service"
    file_permission = "0444"
}