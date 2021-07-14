provider "aws" {
  region = var.aws_region
}

data "aws_subnet" "subnet" {
  id = var.public_subnet_ids[0]
}

data "aws_eip" "public_ip" {
  public_ip = var.public_ip
}

resource "aws_instance" "gitlab" {
  ami                         = var.gitlab_ami
  instance_type               = var.gitlab_instance_type
  associate_public_ip_address = false

  root_block_device {
    volume_type = "standard"
    volume_size = var.gitlab_ebs_size
  }

  vpc_security_group_ids = [
    module.sg_internet_gitlab.security_group_id,
  ]

  subnet_id = var.public_subnet_ids[0]

  iam_instance_profile = aws_iam_instance_profile.gitlab.name

  key_name = aws_key_pair.gitlab.key_name

  tags = merge(var.tags, tomap({
    "Name" = "Gitlab Instance"
  }))
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.gitlab.id
  allocation_id = data.aws_eip.public_ip.id
}

module "sg_internet_gitlab" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_internet_gitlab"
  description = "Security group of gitlab for internet access"
  vpc_id      = data.aws_subnet.subnet.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      description              = "ssh access"
      source_security_group_id = var.bastion_sg_id
    }
  ]

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      description = "http access"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp"
      description = "https access"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = merge(var.tags, tomap({
    "Name" = "sg_internet_gitlab"
  }))
}