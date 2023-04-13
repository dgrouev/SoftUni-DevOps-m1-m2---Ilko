terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "tcp://192.168.99.100:2375/"
}

# One way to deliver the project's files to the Docker host
resource "null_resource" "files" {
  triggers = {
    web_image_id = docker_image.img-web.id
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /project || true",
      "sudo mkdir /project || true",
      "cd /project",
      "sudo git clone https://github.com/shekeriev/bgapp",
    ]

    connection {
      type     = "ssh"
      user     = "vagrant"
      password = "vagrant"
      host     = "192.168.99.100"
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
  # Files are on the Docker host - either copied manually or by using some sort of automation
  volumes {
    host_path      = "/project/bgapp/web"
    container_path = "/var/www/html"
    read_only      = true
  }
  networks_advanced {
    name = "app-net"
  }
  depends_on = [
    null_resource.files,
  ]
}

resource "docker_container" "con-db" {
  name  = "db"
  image = docker_image.img-db.latest
  env   = ["MYSQL_ROOT_PASSWORD=12345"]
  networks_advanced {
    name = "app-net"
  }
}
