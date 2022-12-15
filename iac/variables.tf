variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "private_subnets_cidrs" {
  type        = list(any)
  description = "CIDRs for AWS private subnets"
  default     = ["10.10.0.0/27", "10.10.0.32/27", "10.10.0.64/27"]
}

variable "public_subnets_cidrs" {
  type        = list(any)
  description = "CIDRs for AWS public subnets"
  default     = ["10.10.0.96/27", "10.10.0.128/27", "10.10.0.160/27"]
}

variable "database_subnets_cidrs" {
  type        = list(any)
  description = "CIDRs for AWS database subnets"
  default     = ["10.10.0.192/27", "10.10.0.224/27"]
}

variable "ssh_port" {
  type    = number
  default = 22
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/24"
}