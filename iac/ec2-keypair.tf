module "key_pair" {
  source             = "terraform-aws-modules/key-pair/aws"
  key_name           = "default-key"
  create_private_key = true
  tags = {
    id = "default-key"
  }
}

output "key_pair_private_pem" {
  value     = module.key_pair.private_key_pem
  sensitive = true
}

resource "github_actions_secret" "private_key_github_secret" {
  repository      = "desafio-devops-letscode"
  secret_name     = "PRIVATE_KEY_ARN"
  plaintext_value = module.key_pair.key_pair_arn
}