resource "aws_eks_addon" "addons" {
  count = length(var.eks_addons)
  cluster_name = aws_eks_cluster.this.name
  addon_name   = var.eks_addons.*.name[count.index]
  addon_version = var.eks_addons.*.version[count.index]
}