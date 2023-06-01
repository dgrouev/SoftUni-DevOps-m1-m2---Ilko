terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "img-prometheus" {
  name = "prom/prometheus"
}

resource "docker_image" "img-grafana" {
  name = "grafana/grafana"
}

resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = docker_image.img-prometheus.image_id
  ports {
    internal = 9090
    external = 9090
  }
  networks_advanced {
    name = "exam-net"
  }
  volumes {
    host_path      = "/vagrant/tfm-4-mon/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
    read_only      = true
  }
}

resource "docker_container" "grafana" {
  name = "grafana"
  image = docker_image.img-grafana.image_id
  ports {
    internal = 3000
    external = 3000
  }
  networks_advanced {
    name = "exam-net"
  }
  volumes {
    host_path = "/vagrant/tfm-4-mon/datasource.yml"
    container_path = "/etc/grafana/provisioning/datasource/datasource.yml"
    read_only = true
  }
}
