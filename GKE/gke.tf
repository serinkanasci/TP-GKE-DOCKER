provider "google" {
 credentials = file("tp-gke-docker-9342bc82885c.json")
 project     = "TP-GKE-DOCKER"
 region      = "us-west1"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"
}


resource "google_compute_disk" "default" {
  name  = "tp-disk"
  type  = "pd-balanced"
  size  = 20
  zone  = "us-central1-a"
}

resource "google_compute_network" "MyNetwork" {
  name = "MyNetwork"
  mtu  = 1500
}

resource "kubernetes_deployment" "nginxDeploy" {
  metadata {
    name = "terraform-nginx"
    labels = {
      test = "terraformNginx"
    }
  }
  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "terraformNginx"
      }
    }

    template {
      metadata {
        labels = {
          test = "terraformNginx"
        }
      }

      spec {
        container {
          image = "nginx:1.7.8"
          name  = "nginx"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "grafanaDeploy" {
  metadata {
    name = "terraform-grafana"
    labels = {
      test = "terraformGrafana"
    }
  }
  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "terraformGrafana"
      }
    }

    template {
      metadata {
        labels = {
          test = "terraformGrafana"
        }
      }

      spec {
        container {
          image = "grafana:latest"
          name  = "grafana"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
