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

resource "docker_container" "zookeeper" {
  name = "zookeper"
  image = docker_image.img-zookeeper.image_id
  env = ["ALLOW_ANONYMOUS_LOGIN=yes"]
  ports {
    internal = 2181
    external = 2181
  }
  network_advanced {
    name = "exam-net"
  }
}

resource "docker_container" "kafka" {
  name = "kafka"
  image = docker.image.img-kafka.image_id
  env = ["KAFKA_BROKER_ID=1",
         "KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181",
         "ALLOW_PLAINTEXT_LISTENER=yes"]
  ports {
    internal = 9092
    external = 9092
  }
  network_advanced {
    name = "exam-net"
  }
  depends_on = [ 
    docker_image.img-zookeeper,
   ]
}