# Prerequisites:
# - Local installation of Docker (Desktop)
# - Project files available in D:/data (for Windows) or /data (for Linux)

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_network" "net-docker" {
  name = "app-net"
}

resource "docker_image" "img-web" {
  name = "shekeriev/bgapp-web"
}

resource "docker_image" "img-db" {
  name = "shekeriev/bgapp-db"
}

resource "docker_container" "con-web" {
  name  = "web"
  image = docker_image.img-web.latest
  ports {
    internal = 80
    external = 80
  }
  # Adjust local (host_path) path to the application files
  volumes {
    host_path      = "D:/data/bgapp/web"
    container_path = "/var/www/html"
    read_only      = true
  }
  networks_advanced {
    name = "app-net"
  }
}

resource "docker_container" "con-db" {
  name  = "db"
  image = docker_image.img-db.latest
  env   = ["MYSQL_ROOT_PASSWORD=12345"]
  networks_advanced {
    name = "app-net"
  }
}
