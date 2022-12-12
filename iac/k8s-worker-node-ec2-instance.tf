resource "time_sleep" "wait_240_seconds" {
  depends_on      = [aws_instance.k8s_master_node]
  create_duration = "240s"
}

resource "aws_instance" "k8s_worker_node" {
  count                       = 1
  ami                         = "ami-0a6b2839d44d781b2"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.k8s_worker_node_sg.id]
  subnet_id                   = module.vpc.private_subnets[0]
  key_name                    = module.key_pair.key_pair_name
  iam_instance_profile        = aws_iam_instance_profile.k8s_node_instance_profile.name
  user_data_replace_on_change = true
  lifecycle {
    replace_triggered_by = [
      aws_instance.k8s_master_node
    ]
  }
  depends_on = [
    time_sleep.wait_240_seconds,
    aws_instance.k8s_master_node
  ]
  tags = {
    Name                                         = "worker${count.index}"
    "kubernetes.io/cluster/ada-devops-challenge" = "owned"
  }
  user_data = <<END
#!/bin/bash
swapoff -a
hostnamectl set-hostname ${local.k8s_worker_node_name}${count.index}
apt-get update && apt-get install -y apt-transport-https gnupg2 awscli docker.io
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update && apt-get install -y kubectl kubeadm kubelet=1.25.5-00 kubernetes-cni
systemctl start docker
systemctl enable docker
cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
kubeadm config images pull
echo '{"exec-opts": ["native.cgroupdriver=systemd"]}' | tee /etc/docker/daemon.json
systemctl daemon-reload
systemctl restart docker
systemctl restart kubelet
export AWS_DEFAULT_REGION=${var.aws_region}
sleep 180
aws secretsmanager get-secret-value --secret-id "${aws_secretsmanager_secret.k8s_join_secret.arn}" --query SecretString --output text | bash
END
}

resource "aws_security_group" "k8s_worker_node_sg" {
  name        = "${local.k8s_worker_node_name}-sg"
  description = "Security Group for EC2 instance named ${local.k8s_worker_node_name}"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow all traffic"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
  k8s_worker_node_name = "k8s-worker-node"
}