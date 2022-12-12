resource "kubernetes_deployment" "backend_app" {
  metadata {
    name      = "backend-app"
    namespace = "ada-apps"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        test = "backend-app"
      }
    }
    template {
      metadata {
        labels = {
          test = "backend-app"
        }
      }
      spec {
        container {
          image = "249458120008.dkr.ecr.us-east-1.amazonaws.com/backend-app:latest"
          name  = "backend-app"

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = 8080
            }

          }
          env_from {
            config_map_ref {
              name = "backend-app"
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