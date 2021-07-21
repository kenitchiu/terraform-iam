data "aws_iam_policy_document" "cluster_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cluster" {
  name               = var.cluster_role_name
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json
  managed_policy_arns = [
      "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
      "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
      ]
  description = "Allows access to other AWS service resources that are required to operate clusters managed by EKS."
    tags = merge(var.tags, tomap({
    }))
}

data "aws_iam_policy_document" "node_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "node" {
  name               = var.node_role_name
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json
  managed_policy_arns = [
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
  description = "Allows EC2 instances to call AWS services on your behalf."
    tags = merge(var.tags, tomap({
    }))
}