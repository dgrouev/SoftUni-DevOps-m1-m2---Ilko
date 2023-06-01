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