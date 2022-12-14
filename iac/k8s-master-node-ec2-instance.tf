resource "aws_instance" "k8s_master_node" {
  ami                         = "ami-0a6b2839d44d781b2"
# using t2.micro because of free tier
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
export AWS_DEFAULT_REGION=${var.aws_region}
apt-get update && apt-get install -y apt-transport-https gnupg2 awscli docker.io
hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/hostname)
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update && apt-get install -y kubectl kubeadm kubelet=1.25.5-00 kubernetes-cni
systemctl start docker
systemctl enable docker
cat << EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
kubeadm config images pull
echo '{"exec-opts": ["native.cgroupdriver=systemd"]}' | tee /etc/docker/daemon.json
echo 'KUBELET_EXTRA_ARGS=--cloud-provider=aws' > /etc/default/kubelet
systemctl daemon-reload
systemctl restart docker
systemctl restart kubelet
INSTANCE_IP=$(ip addr | grep 10.10.0 | awk '{print $2}'  | awk -F / '{print $1}')
kubeadm init --apiserver-advertise-address=$INSTANCE_IP --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem
aws secretsmanager update-secret --secret-id "${aws_secretsmanager_secret.k8s_join_secret.arn}" --secret-string "$(kubeadm token create --print-join-command)"
mkdir ~/.kube
cp -i /etc/kubernetes/admin.conf ~/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
aws secretsmanager update-secret --secret-id "${aws_secretsmanager_secret.k8s_kubeconfig.arn}" --secret-string "$(cat /etc/kubernetes/admin.conf)"
aws secretsmanager update-secret --secret-id "${aws_secretsmanager_secret.k8s_cluster_ca_certificate.arn}" --secret-string "$(kubectl config view --minify --raw --output 'jsonpath={..cluster.certificate-authority-data}')"
aws secretsmanager update-secret --secret-id "${aws_secretsmanager_secret.k8s_client_certificate.arn}" --secret-string "$(kubectl config view --minify --raw --output 'jsonpath={..user.client-certificate-data}')"
aws secretsmanager update-secret --secret-id "${aws_secretsmanager_secret.k8s_client_key.arn}" --secret-string "$(kubectl config view --minify --raw --output 'jsonpath={..user.client-key-data}')"
sed -i '20i\    - --cloud-provider=aws' /etc/kubernetes/manifests/kube-controller-manager.yaml
sed -i '20i\    - --cloud-provider=aws' /etc/kubernetes/manifests/kube-apiserver.yaml
systemctl restart kubelet
END
}

resource "aws_security_group" "k8s_master_node_sg" {
  name        = "${local.k8s_master_node_name}-sg"
  description = "Security Group for EC2 instance named ${local.k8s_master_node_name}"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow all traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
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

output "k8s_master_node_ip" {
  value = aws_instance.k8s_master_node.private_ip

}

locals {
  k8s_master_node_name = "k8s-master-node"
}