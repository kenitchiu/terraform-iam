locals {
  arch_ami = {
   "x86" = "AL2_x86_64"
   "arm" = "AL2_ARM_64"
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version = var.k8s_version

  vpc_config {
    subnet_ids = var.cluster_subnet_ids    
  }  

  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
  }

    tags = merge(var.tags, tomap({
        Name = var.cluster_name
    }))
}

resource "aws_eks_node_group" "node_group" {
  count = length(var.node_groups)
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}_node_group_${count.index + 1}"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.node_subnet_ids

  ami_type = local.arch_ami[var.node_groups.*.arch[count.index]]
  capacity_type = var.node_groups.*.capacity_type[count.index]
  disk_size = var.node_groups.*.disk_size[count.index]
  instance_types = var.node_groups.*.instance_types[count.index]

  scaling_config {
    desired_size = var.node_groups.*.desired[count.index]
    max_size     = var.node_groups.*.max[count.index]
    min_size     = var.node_groups.*.min[count.index]
  }
}