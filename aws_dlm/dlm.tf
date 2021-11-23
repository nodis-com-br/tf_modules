resource "aws_iam_role" "this" {
  provider = aws.current
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal =  {
          Service = "dlm.amazonaws.com"
        }
        Effect = "Allow"
        Sid = ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "this" {
  provider = aws.current
  role = aws_iam_role.this.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
         Effect = "Allow",
         Action = [
           "ec2:CreateSnapshot",
           "ec2:CreateSnapshots",
           "ec2:DeleteSnapshot",
           "ec2:DescribeVolumes",
           "ec2:DescribeInstances",
           "ec2:DescribeSnapshots"
         ]
         Resource = "*"
      },
      {
         Effect = "Allow"
         Action = [
            "ec2:CreateTags"
         ]
         Resource = "arn:aws:ec2:*::snapshot/*"
      }
    ]
  })
}

resource "aws_dlm_lifecycle_policy" "daily" {
  provider = aws.current
  for_each = toset(["INSTANCE", "VOLUME"])
  description = "daily backup policy"
  execution_role_arn = aws_iam_role.this.arn
  state  = "ENABLED"
  policy_details {
    resource_types = [each.value]
    schedule {
      name = "1 week of daily snapshots"
      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["00:00",]
      }
      retain_rule {
        count = 7
      }
      tags_to_add = {
        SnapshotCreator = "DLM"
      }
      copy_tags = false
    }
    target_tags = merge({daily_backup = "true"}, var.daily_backup_tags)
  }
}
