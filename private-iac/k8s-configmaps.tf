resource "kubernetes_config_map" "backend_app" {
  metadata {
    name      = "backend-app"
    namespace = var.ada_namespace
  }
  data = {
    MYSQL_DB_HOST = "jdbc:mysql://${data.terraform_remote_state.base_iac.outputs.rds_endpoint}/${data.terraform_remote_state.base_iac.outputs.rds_dbname}?autoReconnect=true&useSSL=false"
    MYSQL_DB_USER = data.terraform_remote_state.base_iac.outputs.rds_username
    MYSQL_DB_PASS = data.terraform_remote_state.base_iac.outputs.rds_password
  }
  depends_on = [
    kubernetes_namespace.ada_apps_namespace
  ]
}