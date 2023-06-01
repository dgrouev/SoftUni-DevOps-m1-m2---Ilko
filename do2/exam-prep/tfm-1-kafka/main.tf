terraform {
  required_providers {
    docker = {
        source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "img-zookeeper" {
  name = "bitnami/zookeeper:latest"
}

resource "docker_image" "img-kafka" {
  name = "bitnami/kafka:latest"
}