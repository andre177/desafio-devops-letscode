resource "aws_db_instance" "db_instance" {
  identifier                  = local.db_identifier
  allocated_storage           = 10
  max_allocated_storage       = 20
  engine                      = "mysql"
  engine_version              = "8.0.28"
  instance_class              = "db.t4g.micro"
  db_name                     = "backendapp"
  username                    = "backendapp"
  password                    = random_password.password.result
  skip_final_snapshot         = true
  backup_retention_period     = 7
  deletion_protection         = false
  final_snapshot_identifier   = "${local.db_identifier}-final"
  backup_window               = "05:00-06:00"
  maintenance_window          = "Sun:06:00-Sun:07:00"
  apply_immediately           = true
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  publicly_accessible         = false
  db_subnet_group_name        = module.vpc.database_subnet_group_name
  port                        = local.port
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  depends_on                  = [aws_security_group.rds_sg]
}

resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "secret_name" {
  name       = aws_db_instance.db_instance.identifier
  depends_on = [aws_db_instance.db_instance]
}

resource "aws_secretsmanager_secret_version" "secret_value" {
  secret_id     = aws_secretsmanager_secret.secret_name.id
  depends_on    = [aws_db_instance.db_instance]
  secret_string = <<EOF
   {
    "username": "${aws_db_instance.db_instance.username}",
    "password": "${aws_db_instance.db_instance.password}"
   }
EOF
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-${local.db_identifier}"
  description = "Security Group for RDS instance named ${local.db_identifier}"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Security Group for RDS instance named ${local.db_identifier}"
    from_port   = local.port
    to_port     = local.port
    protocol    = "tcp"
    cidr_blocks = var.private_subnets_cidrs
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

locals {
  port          = 3306
  db_identifier = "backend-app-mysql-db"
}


