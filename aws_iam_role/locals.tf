locals {
  assume_role_policies = {
    iam_role = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Principal = {
            AWS = var.owner_arn
          }
          Effect = "Allow"
        }
      ]
    })
    ec2_instance = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Effect = "Allow"
          Sid = ""
        }
      ]
    })
  }
}