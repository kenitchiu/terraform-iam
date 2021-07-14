data "aws_iam_policy_document" "robot" {
  count = length(var.robot_policies)
  statement {
    actions   = var.robot_policies[count.index].actions
    resources = var.robot_policies[count.index].resources
  }
}

data "aws_iam_policy_document" "combined_robot" {
  source_policy_documents = data.aws_iam_policy_document.write.*.json
}

resource "aws_iam_policy" "robot" {
  count  = length(var.robot_policies)
  name   = "robot_policy_${count.index}"
  policy = data.aws_iam_policy_document.combined_robot.json
}


data "aws_iam_policy_document" "robot_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.central_account_id}:root"]
    }

    # condition {
    #   test     = "Bool"
    #   variable = "aws:MultiFactorAuthPresent"
    #   values   = ["true"]
    # }

    # condition {
    #   test     = "NumericLessThan"
    #   variable = "aws:MultiFactorAuthAge"
    #   values   = [var.MFAge]
    # }
  }
}

resource "aws_iam_role" "robot" {
  name               = var.robot_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.robot_assume_role.json
}

resource "aws_iam_role_policy_attachment" "robot" {
  count      = length(var.robot_policies)
  role       = aws_iam_role.robot.name
  policy_arn = aws_iam_policy.robot.*.arn[count.index]
}