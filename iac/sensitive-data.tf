resource "aws_secretsmanager_secret" "k8s_join_secret" {
  name = "k8s-join-secret"
  rotation_rules {
    automatically_after_days = 0
  }
}

resource "aws_secretsmanager_secret" "default_key_private" {
  name       = "default-key-private"
  depends_on = [module.key_pair]
  rotation_rules {
    automatically_after_days = 0
  }
}

resource "aws_secretsmanager_secret_version" "default_key_private_value" {
  secret_id     = aws_secretsmanager_secret.default_key_private.id
  secret_string = module.key_pair.private_key_pem
}

resource "aws_secretsmanager_secret" "k8s_client_certificate" {
  name = "k8s-client-certificate"
  rotation_rules {
    automatically_after_days = 0
  }
}

resource "aws_secretsmanager_secret" "k8s_client_key" {
  name = "k8s-client-key"
  rotation_rules {
    automatically_after_days = 0
  }
}

resource "aws_secretsmanager_secret" "k8s_cluster_ca_certificate" {
  name = "k8s-cluster-ca-certificate"
  rotation_rules {
    automatically_after_days = 0
  }
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