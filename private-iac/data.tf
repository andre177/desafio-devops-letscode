data "terraform_remote_state" "base_iac" {
  backend = "s3"
  config = {
    bucket = "ada-devops-challenge"
    key    = "ada-devops-challenge-tfstates"
    region = "us-east-1"
  }
}

data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "ecr_password" {}

data "aws_secretsmanager_secret_version" "k8s_client_certificate" {
  secret_id = data.terraform_remote_state.base_iac.outputs.k8s_client_certificate_arn
}

data "aws_secretsmanager_secret_version" "k8s_client_key" {
  secret_id = data.terraform_remote_state.base_iac.outputs.k8s_client_key
}

data "aws_secretsmanager_secret_version" "k8s_cluster_ca_certificate" {
  secret_id = data.terraform_remote_state.base_iac.outputs.k8s_cluster_ca_certificate
}