resource "kubernetes_namespace" "ada_apps_namespace" {
  metadata {
    annotations = {
      name = var.ada_namespace
    }
    name = var.ada_namespace
  }
}