module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "ada-challenge"
  cidr = var.vpc_cidr

  azs                        = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets            = var.private_subnets_cidrs
  public_subnets             = var.public_subnets_cidrs
  database_subnets           = var.database_subnets_cidrs
  database_subnet_group_name = "rds-subnet-group"

  public_subnet_tags = {
    subnet_type                                  = "public"
    "kubernetes.io/cluster/ada-devops-challenge" = "shared"
    "kubernetes.io/role/elb"                     = 1
  }

  private_subnet_tags = {
    subnet_type                       = "private"
    "kubernetes.io/cluster/prod-eks"  = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }

  database_subnet_tags = {
    subnet_type = "database"
  }

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_dhcp_options    = true

  dhcp_options_domain_name = "ec2.internal"
  dhcp_options_ntp_servers = ["200.160.7.186", "201.49.148.135", "200.186.125.195", "200.20.186.76"]

  tags = {
    id = "default-vpc"
  }
}