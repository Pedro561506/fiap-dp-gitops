terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

provider "docker" {}

variable "db_password" {
  description = "Senha do PostgreSQL"
  type        = string
  sensitive   = true
}

resource "docker_network" "internal" {
  name     = "fiap-dp-internal"
  internal = true
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_image" "postgres" {
  name = "postgres:16-alpine"
}

resource "docker_container" "web" {
  networks_advanced {
    name = docker_network.frontend.name
  }
  name  = "fiap-dp-web"
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.internal.name
  }

  ports {
    internal = 80
    external = 8085
    ip       = "127.0.0.1"
  }
}

resource "docker_container" "database" {
  name  = "fiap-dp-postgres"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_USER=fiap",
    "POSTGRES_DB=fiapdb",
    "POSTGRES_PASSWORD=${var.db_password}"
  ]

  networks_advanced {
    name = docker_network.internal.name
  }
}

resource "docker_network" "frontend" {
  name = "fiap-dp-frontend"
}
