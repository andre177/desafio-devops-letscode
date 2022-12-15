resource "kubernetes_deployment" "backend_app" {
  metadata {
    name      = local.app_name
    namespace = local.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/name" = local.app_name
        "app"                    = local.app_name
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = local.app_name
          "app"                    = local.app_name
        }
      }
      spec {
        container {
          image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${local.app_name}:latest"
          name  = local.app_name

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = local.app_port
            }

          }
          env_from {
            config_map_ref {
              name = local.app_name
            }
          }
        }
        image_pull_secrets {
          name = "regcred"
        }
      }
    }
  }
}

resource "kubernetes_service" "backend_app" {
  metadata {
    name      = local.app_name
    namespace = local.namespace
  }
  spec {
    selector = {
      app = local.app_name
    }
    port {
      port        = 80
      target_port = local.app_port
    }
    type = "LoadBalancer"
  }
}

output "loadbalancer_url" {
  value = kubernetes_service.backend_app.spec
}

locals {
  app_name  = "backend-app"
  namespace = "ada-apps"
  app_port  = 8080
}