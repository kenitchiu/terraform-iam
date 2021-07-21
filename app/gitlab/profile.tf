data "aws_iam_policy_document" "s3" {

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]
    resources = tolist([for i, value in aws_s3_bucket.gitlab.*.arn : "${aws_s3_bucket.gitlab.*.arn[i]}/*"])
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:ListBucketMultipartUploads"
    ]
    resources = aws_s3_bucket.gitlab.*.arn
  }
}

resource "aws_iam_policy" "s3" {
  name   = "gitlab_policy"
  policy = data.aws_iam_policy_document.s3.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "gitlab" {
  name               = "gitlab_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = merge(var.tags, tomap({
    "Name" = "Gitlab S3 role"
  }))
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.gitlab.name
  policy_arn = aws_iam_policy.s3.arn
}

resource "aws_iam_instance_profile" "gitlab" {
  name = "gitlab_profile"
  role = aws_iam_role.gitlab.name
}