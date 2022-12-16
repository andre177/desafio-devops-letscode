resource "kubernetes_deployment" "backend_app" {
  wait_for_rollout = false
  metadata {
    name      = local.backend_app_name
    namespace = var.ada_namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/name" = local.backend_app_name
        "app"                    = local.backend_app_name
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = local.backend_app_name
          "app"                    = local.backend_app_name
        }
      }
      spec {
        container {
          image             = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${local.backend_app_name}:latest"
          name              = local.backend_app_name
          image_pull_policy = "Always"

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = local.backend_app_port
            }

          }
          env_from {
            config_map_ref {
              name = local.backend_app_name
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
    name      = local.backend_app_name
    namespace = var.ada_namespace
  }
  spec {
    selector = {
      app = local.backend_app_name
    }
    port {
      port        = 80
      target_port = local.backend_app_port
    }
    type = "LoadBalancer"
  }
}

output "backendapp_load_balancer_hostname" {
  value = kubernetes_service.backend_app.status.0.load_balancer.0.ingress.0.hostname
}

locals {
  backend_app_name = "backend-app"
  backend_app_port = 8080
}