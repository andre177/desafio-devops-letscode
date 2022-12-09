resource "aws_iam_role" "k8s_node" {
  name = "K8sNodeRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "ec2.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "node" {
  name   = "node-k8s-policy"
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Sid": "K8sNodeDescribeResources",
		"Effect": "Allow",
		"Action": ["ec2:DescribeInstances", "ec2:DescribeRegions"],
		"Resource": "*"
	}]
}
EOF
}

resource "aws_iam_policy" "k8s_join_secret_ro" {
  name   = "k8s-join-secret-ro-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Resource": "${aws_secretsmanager_secret.k8s_join_secret.arn}"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "k8s_node_role_k8s_join_secret_ro_policy" {
  role       = aws_iam_role.k8s_node.name
  policy_arn = aws_iam_policy.k8s_join_secret_ro.arn
}

resource "aws_iam_role_policy_attachment" "k8s_node_role_node_policy" {
  role       = aws_iam_role.k8s_node.name
  policy_arn = aws_iam_policy.node.arn
}

resource "aws_iam_role_policy_attachment" "k8s_node_role_ecr_policy" {
  role       = aws_iam_role.k8s_node.name
  policy_arn = aws_iam_policy.ecr.arn
}

resource "aws_iam_role_policy_attachment" "k8s_node_role_cni_policy" {
  role       = aws_iam_role.k8s_node.name
  policy_arn = aws_iam_policy.cni.arn
}