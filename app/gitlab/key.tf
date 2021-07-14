resource "aws_key_pair" "gitlab" {
  key_name   = "gitlab-access-key"
  public_key = var.gitlab_public_key
  tags = merge(var.tags, tomap({
    "Name" = "Gitlab key pair",
  }))
}