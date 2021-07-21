data "aws_iam_policy_document" "jenkins" {
  count = length(var.profile_policies)
  statement {
    actions   = var.profile_policies[count.index].actions
    resources = var.profile_policies[count.index].resources
  }
}

resource "aws_iam_policy" "jenkins" {
  count  = length(var.profile_policies)
  name   = "jenkins_policy_${count.index}"
  policy = data.aws_iam_policy_document.jenkins.*.json[count.index]
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

resource "aws_iam_role" "jenkins" {
  name               = "jenkins_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = merge(var.tags, tomap({
    "Name" = "Role of Jenkins"
  }))
}

resource "aws_iam_role_policy_attachment" "jenkins" {
  count      = length(var.profile_policies)
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins.*.arn[count.index]
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "jenkins_profile"
  role = aws_iam_role.jenkins.name
  tags = merge(var.tags, tomap({
    "Name" = "Profile of Jenkins"
  }))
}