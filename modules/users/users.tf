resource "aws_iam_user" "human_accounts" {
  count = length(var.human_accounts)
  name  = var.human_accounts[count.index]
}

resource "aws_iam_group_membership" "human_account" {
  name = "${var.human_group_name}-membership"
  users = aws_iam_user.human_accounts.*.name
  group = aws_iam_group.human_account.name
}