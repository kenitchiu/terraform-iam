resource "aws_key_pair" "jenkins" {
  key_name   = "jenkins-access-key"
  public_key = var.ssh_public_key
  tags = merge(var.tags, tomap({
    "Name" = "Jenkins key pair",
  }))
}