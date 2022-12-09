resource "aws_iam_instance_profile" "k8s_master_instance_profile" {
  name = "K8sMasterInstanceProfile"
  role = aws_iam_role.k8s_master.name
}

resource "aws_iam_instance_profile" "k8s_node_instance_profile" {
  #test
  name = "K8sNodeInstanceProfile"
  role = aws_iam_role.k8s_node.name
}