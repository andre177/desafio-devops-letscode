resource "kubernetes_secret" "ecr_registry" {
  metadata {
    name = "regcred"
  }
  type = "kubernetes.io/dockerconfigjson"
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${data.aws_caller_identity.current.account_id}.dkr.ecr.region.amazonaws.com" = {
          "username" = "AWS"
          "password" = data.aws_ecr_authorization_token.ecr_password.password
          "email"    = "andreferreira177@outlook.com.br"
          "auth"     = base64encode("AWS:${data.aws_ecr_authorization_token.ecr_password.password}")
        }
      }
    })
  }
}