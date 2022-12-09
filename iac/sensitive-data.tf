resource "aws_secretsmanager_secret" "k8s_join_secret" {
  name = "k8s-join-secret"
}

resource "aws_secretsmanager_secret" "default_key_private" {
  name       = "default-key-private"
  depends_on = [module.key_pair]
}

resource "aws_secretsmanager_secret_version" "default_key_private_value" {
  secret_id     = aws_secretsmanager_secret.default_key_private.id
  secret_string = module.key_pair.private_key_pem
}
