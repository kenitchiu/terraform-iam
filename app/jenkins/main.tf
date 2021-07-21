provider "aws" {
  region = var.aws_region
}

data "aws_subnet" "subnet" {
  id = var.public_subnet_ids[0]
}

data "aws_eip" "public_ip" {
  public_ip = var.public_ip
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = false

  root_block_device {
    volume_type = "standard"
    volume_size = var.ebs_size
  }

  vpc_security_group_ids = [
    module.sg_internet_jenkins.security_group_id,
  ]

  subnet_id = var.public_subnet_ids[0]

  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  key_name = aws_key_pair.jenkins.key_name

  tags = merge(var.tags, tomap({
    "Name" = "Jenkins Instance"
  }))
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.jenkins.id
  allocation_id = data.aws_eip.public_ip.id
}

module "sg_internet_jenkins" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_internet_jenkins"
  description = "Security group of Jenkins for internet access"
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
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
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
    "Name" = "sg_internet_jenkins"
  }))
}