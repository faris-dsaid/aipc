data digitalocean_ssh_key aipc {
    name = "aipc"
}

data docker_image dov-bear {
    name = "chukmunnlee/dov-bear:v2"
}

resource docker_container dov-bear-container {
    count = var.app_instances
    name = "dov-bear-${count.index}"
    image = data.docker_image.dov-bear.id
    env = [
        "INSTANCE_NAME=myapp-${count.index}",
        "INSTANCE_HASH=${count.index}"
    ]
    ports {
        internal = 3000
    }
}

resource local_file root_at_nginx {
    content = ""
    filename = "root@${digitalocean_droplet.nginx.ipv4_address}"
}

resource local_file nginx-conf {
    content = templatefile("./nginx.conf.tpl", {
        host_ip = var.docker_host_ip 
        container_ports = docker_container.dov-bear-container[*].ports[0].external
    })
    filename = "nginx.conf"
    file_permission = "0444"
}

/* ---- nginx --- */
resource digitalocean_droplet nginx {
    name = "nginx"
    image = var.DO_image
    size = var.DO_size
    region = var.DO_region
    ssh_keys = [ data.digitalocean_ssh_key.aipc.id ]
    connection {
        type = "ssh"
        user = "root"
        private_key = file(var.DO_private_key)
        host = self.ipv4_address
    }
    provisioner remote-exec {
        inline = [
            "apt update",
            "apt install nginx -y",
            "systemctl enable nginx",
            "systemctl start nginx"
        ]
    }
    provisioner file {
        source = "./nginx.conf"
        destination = "/etc/nginx/nginx.conf"
    }
    provisioner remote-exec {
        inline = [
            "systemctl restart nginx"
        ]
    }
}

output container_ports {
    value = docker_container.dov-bear-container[*].ports[0].external
}

output nginx_ip {
    value = digitalocean_droplet.nginx.ipv4_address
}
