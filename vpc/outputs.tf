output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "eks_public_subnet_ids" {
  value = aws_subnet.eks_public.*.id
}

output "eks_private_subnet_ids" {
  value = aws_subnet.eks_private.*.id
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_key_name" {
  value = aws_key_pair.bastion.key_name
}

output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}