resource "aws_iam_role" "k8s_master" {
  name = "K8sMasterRole"

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

resource "aws_iam_policy" "k8s_master" {
  name   = "k8s-master-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ec2:*"],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": ["elasticloadbalancing:*"],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": ["route53:*"],
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::kubernetes-*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "k8s_master_role_loadbalancing_policy" {
  role       = aws_iam_role.k8s_master.name
  policy_arn = aws_iam_policy.k8s_master.arn
}

resource "aws_iam_policy" "k8s_join_secret_rw" {
  name   = "k8s-join-secret-rw-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "secretsmanager:*",
            "Resource": "${aws_secretsmanager_secret.k8s_join_secret.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "k8s_master_role_k8s_join_secret_rw_policy" {
  role       = aws_iam_role.k8s_master.name
  policy_arn = aws_iam_policy.k8s_join_secret_rw.arn
}

resource "aws_iam_policy" "k8s_client_certificate_rw" {
  name   = "k8s-client-certificate-rw-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "secretsmanager:*",
            "Resource": "${aws_secretsmanager_secret.k8s_client_certificate.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "k8s_master_role_k8s_client_certificate_rw_policy" {
  role       = aws_iam_role.k8s_master.name
  policy_arn = aws_iam_policy.k8s_client_certificate_rw.arn
}

resource "aws_iam_policy" "k8s_client_key_rw" {
  name   = "k8s-client-key-rw-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "secretsmanager:*",
            "Resource": "${aws_secretsmanager_secret.k8s_client_key.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "k8s_master_role_k8s_client_key_rw_policy" {
  role       = aws_iam_role.k8s_master.name
  policy_arn = aws_iam_policy.k8s_client_key_rw.arn
}

resource "aws_iam_policy" "k8s_cluster_ca_certificate_rw" {
  name   = "k8s-cluster-ca-certificate-rw-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "secretsmanager:*",
            "Resource": "${aws_secretsmanager_secret.k8s_cluster_ca_certificate.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "k8s_master_role_k8s_cluster_ca_certificate_rw_policy" {
  role       = aws_iam_role.k8s_master.name
  policy_arn = aws_iam_policy.k8s_cluster_ca_certificate_rw.arn
}