
data "docker_image" "myapp" {
  name = "stackupiss/northwind-app:v1"
}

data "docker_image" "mydb" {
  name = "stackupiss/northwind-db:v1"
}

resource "docker_network" "mynet" {
  name = "mynet"
}

resource "docker_volume" "nwdb_vol" {
  name = "nwdb-vol"
}

resource docker_container myapp-container {
    name = "myapp"
    image = data.docker_image.myapp.id
    networks_advanced {
        name =  docker_network.mynet.name
    }
    env = [
        "DB_HOST=${docker_container.mydb-container.name}",
        "DB_USER=root",
        "DB_PASSWORD=changeit"
    ]
    ports {
        internal = 3000
        external = 3000
    }
}

resource docker_container mydb-container {
    name = "mydb"
    image = data.docker_image.mydb.id
    volumes {
        volume_name = docker_volume.nwdb_vol.name
        container_path = "/var/lib/mysql"
    }
    networks_advanced {
        name = docker_network.mynet.name
    }
    ports {
        internal = 3306
        external = 3306
    }
}
