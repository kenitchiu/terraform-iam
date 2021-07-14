data "aws_iam_policy_document" "write" {
  count = length(var.write_policies)
  statement {
    actions   = var.write_policies[count.index].actions
    resources = var.write_policies[count.index].resources
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

data "aws_iam_policy_document" "combined_write" {
  source_policy_documents = data.aws_iam_policy_document.write.*.json
}


resource "aws_iam_policy" "write" {
  count  = length(var.write_policies)
  name   = "write_policy_${count.index}"
  policy = data.aws_iam_policy_document.combined_write.json
}

data "aws_iam_policy_document" "write_assume_role" {
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

resource "aws_iam_role" "write" {
  name               = var.write_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.write_assume_role.json
}

resource "aws_iam_role_policy_attachment" "write" {
  count      = length(var.write_policies)
  role       = aws_iam_role.write.name
  policy_arn = aws_iam_policy.write.*.arn[count.index]
}