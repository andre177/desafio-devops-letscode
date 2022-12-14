resource "aws_secretsmanager_secret" "k8s_join_secret" {
  name = "k8s-join-secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "default_key_private" {
  name       = "default-key-private"
  depends_on = [module.key_pair]
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "k8s_kubeconfig" {
  name       = "k8s-kubeconfig"
  recovery_window_in_days = 0
}

resource "github_actions_secret" "k8s_kubeconfig" {
  repository      = "desafio-devops-letscode"
  secret_name     = "KUBECONFIG"
  plaintext_value = aws_secretsmanager_secret.k8s_kubeconfig.arn
}

resource "github_actions_secret" "private_key_github_secret" {
  repository      = "desafio-devops-letscode"
  secret_name     = "PRIVATE_KEY_ARN"
  plaintext_value = aws_secretsmanager_secret.default_key_private.arn
}

resource "aws_secretsmanager_secret_version" "default_key_private_value" {
  secret_id     = aws_secretsmanager_secret.default_key_private.id
  secret_string = module.key_pair.private_key_pem
}

resource "aws_secretsmanager_secret" "k8s_client_certificate" {
  name = "k8s-client-certificate"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "k8s_client_key" {
  name = "k8s-client-key"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret" "k8s_cluster_ca_certificate" {
  name = "k8s-cluster-ca-certificate"
  recovery_window_in_days = 0
}

output "k8s_client_certificate_arn" {
  value = aws_secretsmanager_secret.k8s_client_certificate.arn
}

output "k8s_client_key" {
  value = aws_secretsmanager_secret.k8s_client_key.arn
}

output "k8s_cluster_ca_certificate" {
  value = aws_secretsmanager_secret.k8s_cluster_ca_certificate.arn
}