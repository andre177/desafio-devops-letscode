resource "kubernetes_namespace" "ada_apps" {
  metadata {
    annotations = {
      name = var.ada_namespace
    }
    name = var.ada_namespace
  }
}