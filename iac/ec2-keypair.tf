module "key_pair" {
  source             = "terraform-aws-modules/key-pair/aws"
  key_name           = "default-key"
  create_private_key = true
}

output "key_pair_private_pem" {
  value     = module.key_pair.private_key_pem
  sensitive = true
}