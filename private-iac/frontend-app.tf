resource "kubernetes_deployment" "frontend_app" {
  metadata {
    name      = local.frontend_app_name
    namespace = var.ada_namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/name" = local.frontend_app_name
        "app"                    = local.frontend_app_name
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = local.frontend_app_name
          "app"                    = local.frontend_app_name
        }
      }
      spec {
        container {
          image             = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${local.frontend_app_name}:latest"
          name              = local.frontend_app_name
          image_pull_policy = "Always"
        }
        image_pull_secrets {
          name = "regcred"
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend_app" {
  metadata {
    name      = local.frontend_app_name
    namespace = var.ada_namespace
  }
  spec {
    selector = {
      app = local.frontend_app_name
    }
    port {
      port        = 80
      target_port = local.frontend_app_port
    }
    type = "LoadBalancer"
  }
}

output "frontendapp_load_balancer_hostname" {
  value = kubernetes_service.frontend_app.status.0.load_balancer.0.ingress.0.hostname
}

locals {
  frontend_app_name = "frontend-app"
  frontend_app_port = 4200
}