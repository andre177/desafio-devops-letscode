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

resource "aws_iam_policy" "master" {
  name   = "master-k8s-policy"
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Sid": "K8sMasterDescribeResources",
		"Effect": "Allow",
		"Action": ["ec2:DescribeInstances", "ec2:DescribeRegions", "ec2:DescribeRouteTables", "ec2:DescribeSecurityGroups", "ec2:DescribeSubnets", "ec2:DescribeVolumes"],
		"Resource": "*"
	}, {
		"Sid": "K8sMasterAllResourcesWriteable",
		"Effect": "Allow",
		"Action": ["ec2:CreateRoute", "ec2:CreateSecurityGroup", "ec2:CreateTags", "ec2:CreateVolume", "ec2:ModifyInstanceAttribute"],
		"Resource": "*"
	}, {
		"Sid": "K8sMasterTaggedResourcesWritable",
		"Effect": "Allow",
		"Action": ["ec2:AttachVolume", "ec2:AuthorizeSecurityGroupIngress", "ec2:DeleteRoute", "ec2:DeleteSecurityGroup", "ec2:DeleteVolume", "ec2:DetachVolume", "ec2:RevokeSecurityGroupIngress"],
		"Resource": "*"
	}]
}
EOF
}

resource "aws_iam_role_policy_attachment" "k8s_master_role_master_policy" {
  role       = aws_iam_role.k8s_master.name
  policy_arn = aws_iam_policy.master.arn
}

resource "aws_iam_policy" "ecr" {
  name   = "ecr-k8s-policy"
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Sid": "K8sECR",
		"Effect": "Allow",
		"Action": ["ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability", "ecr:GetDownloadUrlForLayer", "ecr:GetRepositoryPolicy", "ecr:DescribeRepositories", "ecr:ListImages", "ecr:BatchGetImage"],
		"Resource": "*"
	}]
}
EOF
}

resource "aws_iam_role_policy_attachment" "k8s_master_role_ecr_policy" {
  role       = aws_iam_role.k8s_master.name
  policy_arn = aws_iam_policy.ecr.arn
}

resource "aws_iam_policy" "cni" {
  name   = "cni-k8s-policy"
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Sid": "K8sNodeAwsVpcCNI",
		"Effect": "Allow",
		"Action": ["ec2:CreateNetworkInterface", "ec2:AttachNetworkInterface", "ec2:DeleteNetworkInterface", "ec2:DetachNetworkInterface", "ec2:DescribeNetworkInterfaces", "ec2:DescribeInstances", "ec2:ModifyNetworkInterfaceAttribute", "ec2:AssignPrivateIpAddresses", "tag:TagResources"],
		"Resource": "*"
	}]
}
EOF
}

resource "aws_iam_role_policy_attachment" "k8s_master_role_cni_policy" {
  role       = aws_iam_role.k8s_master.name
  policy_arn = aws_iam_policy.cni.arn
}

resource "aws_iam_policy" "autoscaler" {
  name   = "autoscaler-k8s-policy"
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Sid": "K8sClusterAutoscalerDescribe",
		"Effect": "Allow",
		"Action": ["autoscaling:DescribeAutoScalingGroups", "autoscaling:DescribeAutoScalingInstances", "autoscaling:DescribeTags", "autoscaling:DescribeLaunchConfigurations"],
		"Resource": "*"
	}, {
		"Sid": "K8sClusterAutoscalerTaggedResourcesWritable",
		"Effect": "Allow",
		"Action": ["autoscaling:SetDesiredCapacity", "autoscaling:TerminateInstanceInAutoScalingGroup", "autoscaling:UpdateAutoScalingGroup"],
		"Resource": "*"
	}]
}
EOF
}

resource "aws_iam_role_policy_attachment" "k8s_master_role_autoscaler_policy" {
  role       = aws_iam_role.k8s_master.name
  policy_arn = aws_iam_policy.autoscaler.arn
}

resource "aws_iam_policy" "loadbalancing" {
  name   = "loadbalancing-k8s-policy"
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Sid": "K8sELB",
		"Effect": "Allow",
		"Action": ["elasticloadbalancing:AddTags", "elasticloadbalancing:AttachLoadBalancerToSubnets", "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer", "elasticloadbalancing:CreateLoadBalancer", "elasticloadbalancing:CreateLoadBalancerPolicy", "elasticloadbalancing:CreateLoadBalancerListeners", "elasticloadbalancing:ConfigureHealthCheck", "elasticloadbalancing:DeleteLoadBalancer", "elasticloadbalancing:DeleteLoadBalancerListeners", "elasticloadbalancing:DescribeLoadBalancers", "elasticloadbalancing:DescribeLoadBalancerAttributes", "elasticloadbalancing:DetachLoadBalancerFromSubnets", "elasticloadbalancing:DeregisterInstancesFromLoadBalancer", "elasticloadbalancing:ModifyLoadBalancerAttributes", "elasticloadbalancing:RegisterInstancesWithLoadBalancer", "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer"],
		"Resource": "*"
	}, {
		"Sid": "K8sNLB",
		"Effect": "Allow",
		"Action": ["ec2:DescribeVpcs", "elasticloadbalancing:AddTags", "elasticloadbalancing:CreateListener", "elasticloadbalancing:CreateTargetGroup", "elasticloadbalancing:DeleteListener", "elasticloadbalancing:DeleteTargetGroup", "elasticloadbalancing:DescribeListeners", "elasticloadbalancing:DescribeLoadBalancerPolicies", "elasticloadbalancing:DescribeTargetGroups", "elasticloadbalancing:DescribeTargetHealth", "elasticloadbalancing:ModifyListener", "elasticloadbalancing:ModifyTargetGroup", "elasticloadbalancing:RegisterTargets", "elasticloadbalancing:SetLoadBalancerPoliciesOfListener"],
		"Resource": "*"
	}]
}
EOF
}

resource "aws_iam_role_policy_attachment" "k8s_master_role_loadbalancing_policy" {
  role       = aws_iam_role.k8s_master.name
  policy_arn = aws_iam_policy.loadbalancing.arn
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