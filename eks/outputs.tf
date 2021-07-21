output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "addons" {
  value = tomap({
    for i, value in aws_eks_addon.addons : aws_eks_addon.addons.*.addon_name[i] => aws_eks_addon.addons.*.addon_version[i]
  })
}