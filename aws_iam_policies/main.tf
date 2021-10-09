resource "aws_iam_policy" "this" {
  provider = aws.current
  for_each = toset(local.policy_files)
  name = each.key
  policy = data.local_file.policy[each.key].content
}
