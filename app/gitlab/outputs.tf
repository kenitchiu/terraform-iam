output "gitlab_public_ip" {
  description = "Public IP address of the gitlab service."
  value       = aws_eip_association.eip_assoc.public_ip
}

output "gitlab_private_ip" {
  description = "Public IP address of the gitlab service."
  value       = aws_instance.gitlab.private_ip
}

output "gitlab_sg_id" {
  description = "The id of security group assigned to gitlab for internet access"
  value       = module.sg_internet_gitlab.security_group_id
}

output "postgres_sg_id" {
  description = "The id of security group assigned to postgres"
  value       = module.sg_postgres.security_group_id
}

output "postgres_endpoint" {
  value = module.db.db_instance_endpoint
}