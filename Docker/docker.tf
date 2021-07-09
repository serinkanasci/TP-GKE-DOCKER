terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.14.0"
    }
  }
}

# Setting up docker network
resource "docker_network" "network_named" {
  name       = "MyBridgedNetwork"
  driver     = "bridge"
}

resource "docker_network" "network_ETH" {
  name       = "BCNetwork"
  driver     = "bridge"
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  name  = "nginx_container"
  image = docker_image.nginx.name
    networks = [ "${docker_network.network_named.name}"]
}

