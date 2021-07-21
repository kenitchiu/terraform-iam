output "public_ip" {
  description = "Public IP address of the Jenkins."
  value       = aws_eip_association.eip_assoc.public_ip
}

output "private_ip" {
  description = "Public IP address of the Jenkins."
  value       = aws_instance.jenkins.private_ip
}

output "security_group_id" {
  description = "The id of security group assigned to Jenkins for internet access"
  value       = module.sg_internet_jenkins.security_group_id
}