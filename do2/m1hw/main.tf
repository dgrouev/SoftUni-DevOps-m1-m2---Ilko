terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "tcp://192.168.99.100:2375/"
}

resource "docker_container" "con-web" {
  name  = var.v_con_name_web
  image = docker_image.img-web.image_id
  depends_on = [
    docker_container.con-db
  ]
  mounts {
    target    = "/var/www/html"
    type      = "bind"
    read_only = true
    source    = "/home/vagrant/bgapp/web"
  }
  ports {
    internal = var.v_int_port_web
    external = var.v_ext_port_web
  }
  networks_advanced {
    name = "app-net"
  }
}

resource "docker_image" "img-web" {
  name = var.v_image_web
}


resource "docker_container" "con-db" {
  name         = var.v_con_name_db
  image        = docker_image.img-db.image_id
  network_mode = "app-net"
  env          = ["MYSQL_ROOT_PASSWORD=12345"]
  restart      = "no"
  must_run     = "true"
  ports {
    internal = var.v_int_port_db
    external = var.v_ext_port_db
  }
}

resource "docker_image" "img-db" {
  name = var.v_image_db
}
