resource "aws_instance" "k8s_master_node" {
  ami                         = "ami-0a6b2839d44d781b2"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.k8s_master_node_sg.id]
  subnet_id                   = module.vpc.private_subnets[0]
  key_name                    = module.key_pair.key_pair_name
  iam_instance_profile        = aws_iam_instance_profile.k8s_master_instance_profile.name
  user_data_replace_on_change = true
  tags = {
    Name                                         = local.k8s_master_node_name
    "kubernetes.io/cluster/ada-devops-challenge" = "owned"
  }
  user_data = <<END
#!/bin/bash
swapoff -a
hostnamectl set-hostname master
export AWS_DEFAULT_REGION=${var.aws_region}
apt-get update && apt-get install -y apt-transport-https gnupg2 awscli
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update && apt-get install -y kubectl kubeadm kubelet kubernetes-cni docker.io
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
INSTANCE_IP=$(ip addr | grep 10.10.0 | awk '{print $2}'  | awk -F / '{print $1}')
kubeadm init --apiserver-advertise-address=$INSTANCE_IP --pod-network-cidr=${var.vpc_cidr} --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem
aws secretsmanager update-secret --secret-id "${aws_secretsmanager_secret.k8s_join_secret.arn}" --secret-string "$(kubeadm token create --print-join-command)"
mkdir ~/.kube
cp -i /etc/kubernetes/admin.conf ~/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
END
}

resource "aws_security_group" "k8s_master_node_sg" {
  name        = "${local.k8s_master_node_name}-sg"
  description = "Security Group for EC2 instance named ${local.k8s_master_node_name}"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow all traffic from bastion host"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id]
  }

  ingress {
    description = "Allow all traffic for internal subnets"
    from_port   = 0
    to_port     = 65535
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
  k8s_master_node_name = "k8s-master-node"
}