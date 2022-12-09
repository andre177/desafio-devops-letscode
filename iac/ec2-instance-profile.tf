resource "aws_iam_instance_profile" "k8s_master_instance_profile" {
  name = "K8sMasterInstanceProfile"
  role = aws_iam_role.k8s_master.name
}