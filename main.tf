terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_image" "postgres" {
  name = "postgres:16-alpine"
}

resource "docker_container" "web" {
  name  = "fiap-dp-web"
  image = docker_image.nginx.image_id

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
    "POSTGRES_PASSWORD=SenhaLaboratorio123"
  ]

  ports {
    internal = 5432
    external = 5433
    ip       = "0.0.0.0"
  }
}
