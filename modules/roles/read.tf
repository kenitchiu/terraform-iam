data "aws_iam_policy_document" "read" {
  count = length(var.read_policies)
  statement {
    actions   = var.read_policies[count.index].actions
    resources = var.read_policies[count.index].resources
  }

  # permission to operate terraform remote state lock, the resource part need to be modified for fitting the real situation
  #statement {
  #  actions = [
  #    "dynamodb:*"
  #  ]
  #
  #  resources = [
  #    "arn:aws:dynamodb:*:*:table/${var.account_alias}.tfstate"
  #  ]
  #}
}


data "aws_iam_policy_document" "combined_read" {
  source_policy_documents = data.aws_iam_policy_document.read.*.json
}

resource "aws_iam_policy" "read" {
  count = length(var.read_policies)
  name   = "read_policy_${count.index}"
  policy = data.aws_iam_policy_document.read.*.json[count.index]
}

data "aws_iam_policy_document" "read_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.central_account_id}:root"]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = [var.MFAge]
    }
  }
}

resource "aws_iam_role" "read" {
  name               = var.read_account_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.read_assume_role.json
}

resource "aws_iam_role_policy_attachment" "read" {
  count = length(var.read_policies)
  role       = aws_iam_role.read.name
  policy_arn = aws_iam_policy.read.*.arn[count.index]
}