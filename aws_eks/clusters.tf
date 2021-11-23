### Cluster role ######################

resource "aws_iam_role" "cluster" {
  provider = aws.current
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "cluster" {
  provider = aws.current
  role = aws_iam_role.cluster.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:CreateServiceLinkedRole"
        ],
        Resource = [
          "arn:aws:iam::*:role/aws-service-role/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeInternetGateways"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  provider = aws.current
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSServicePolicy" {
  provider = aws.current
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = aws_iam_role.cluster.name
}


### Cluster ###########################

resource "aws_eks_cluster" "this" {
  provider = aws.current
  name = var.name
  role_arn = aws_iam_role.cluster.arn
  vpc_config {
    subnet_ids = var.subnet_ids
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy
  ]
}

### Security group rules ##############

resource "aws_security_group_rule" "this" {
  provider = aws.current
  for_each = var.ingress_rules
  security_group_id = aws_eks_cluster.this.vpc_config.0.cluster_security_group_id
  type = "ingress"
  from_port = each.value.from_port
  to_port = each.value.to_port
  protocol = each.value.protocol
  cidr_blocks = each.value.cidr_blocks
}

### IAM integration

resource "aws_iam_openid_connect_provider" "this" {
  provider = aws.current
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result.thumbprint]
  url = aws_eks_cluster.this.identity.0.oidc.0.issuer
}

resource "aws_iam_role" "sa" {
  provider = aws.current
  for_each = {for sa in local.roles : sa.service_account => sa}
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.this.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub": "system:serviceaccount:${each.value.namespace}:${each.key}"
          }
        }
      }
    ]
  })
  depends_on = [
    aws_iam_openid_connect_provider.this
  ]

}

resource "aws_iam_role_policy_attachment" "sa" {
  provider = aws.current
  for_each = {for sa in local.policiy_attachments : "${sa.service_account}-${sa.policy.name}" => sa}
  role = aws_iam_role.sa[each.value.service_account].name
  policy_arn = each.value.policy.arn
}
