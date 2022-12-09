resource "aws_instance" "bastion_host" {
  ami                    = "ami-0574da719dca65348"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]
  subnet_id              = module.vpc.public_subnets[0]
  tags                   = { Name = local.bastion_host_name }
  key_name               = module.key_pair.key_pair_name
  user_data              = <<EOF
#!/bin/bash
echo ${module.key_pair.private_key_pem} >> /home/ubuntu/.ssh/aws.pem
chmod 400 /home/ubuntu/.ssh/aws.pem
EOF
}


resource "aws_security_group" "bastion_host_sg" {
  name        = "ec2-${local.bastion_host_name}"
  description = "Security Group for AMI EC2 instance named ${local.bastion_host_name}"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Security Group for AMI EC2 instance named ${local.bastion_host_name}"
    from_port        = var.ssh_port
    to_port          = var.ssh_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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
  bastion_host_name = "bastion-host"
}