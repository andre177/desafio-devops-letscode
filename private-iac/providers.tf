terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
  }
}

provider "kubernetes" {
  host                   = "https://${data.terraform_remote_state.base_iac.outputs.k8s_master_node_ip}:6443"
  client_certificate     = base64decode("${data.aws_secretsmanager_secret_version.k8s_client_certificate.secret_string}")
  client_key             = base64decode("${data.aws_secretsmanager_secret_version.k8s_client_key.secret_string}")
  cluster_ca_certificate = base64decode("${data.aws_secretsmanager_secret_version.k8s_cluster_ca_certificate.secret_string}")
}