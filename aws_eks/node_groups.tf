### Node Group Role ###################

resource "aws_iam_role" "node_group" {
  provider = aws.current
  for_each = var.node_groups
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "node_group-ec2_autoscaler" {
  provider = aws.current
  for_each = var.node_groups
  role = aws_iam_role.node_group[each.key].name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Resource = "*"
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "node_group-ebs-cni-driver" {
  provider = aws.current
  for_each = var.node_groups
  role = aws_iam_role.node_group[each.key].name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:AttachVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteSnapshot",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DetachVolume",
          "ec2:ModifyVolume"
        ]
        Resource = "*"
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_group-AmazonEC2ContainerRegistryReadOnly" {
  provider = aws.current
  for_each = var.node_groups
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group[each.key].name
}

resource "aws_iam_role_policy_attachment" "node_group-AmazonEKSWorkerNodePolicy" {
  for_each = var.node_groups
  provider = aws.current
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group[each.key].name
}

resource "aws_iam_role_policy_attachment" "node_group-AmazonEKS_CNI_Policy" {
  for_each = var.node_groups
  provider = aws.current
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group[each.key].name
}


### Task execution role ###############

resource "aws_iam_role" "ecs_task_execution" {
  for_each = var.node_groups
  provider = aws.current
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}


### Node Group ########################

resource "aws_launch_template" "this" {
  provider = aws.current
  for_each = var.node_groups
  key_name = each.value.ssh_key
  tag_specifications {
    resource_type = "instance"
    tags = merge({
      Name = "${var.name}-${each.key}"
    }, each.value.tags)
  }
}

resource "aws_eks_node_group" "this" {
  provider = aws.current
  for_each = var.node_groups
  cluster_name = var.name
  node_group_name = each.key
  node_role_arn = aws_iam_role.node_group[each.key].arn
  subnet_ids = each.value.subnet_ids
  instance_types = [
    each.value.instance_type
  ]
  labels = {
    nodePoolName = each.key
  }
  scaling_config {
    desired_size = each.value.desired_size
    max_size = each.value.max_size
    min_size = each.value.min_size
  }
  launch_template {
    version = aws_launch_template.this[each.key].latest_version
    id = aws_launch_template.this[each.key].id
  }
  depends_on = [
    aws_iam_role_policy_attachment.node_group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_group-AmazonEC2ContainerRegistryReadOnly,
  ]

  lifecycle {
    ignore_changes = [
      scaling_config.0.desired_size
    ]
  }
}
