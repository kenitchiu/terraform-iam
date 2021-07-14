resource "aws_key_pair" "bastion" {
  key_name   = "bastion-access-key"
  public_key = var.bastion_public_key
  tags = {
    Name = "Bastion"
  }
}

resource "aws_security_group" "bastion" {
  vpc_id = module.vpc.vpc_id

  tags = {
    "Name" = "Bastion",
  }
}

resource "aws_security_group_rule" "bastion_egress" {
  type              = "egress"
  security_group_id = aws_security_group.bastion.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion_ingress_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.bastion.id

  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 22
  to_port     = 22
}

resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami
  associate_public_ip_address = true
  instance_type               = var.bastion_instance_type
  key_name                    = aws_key_pair.bastion.key_name
  source_dest_check           = true
  subnet_id                   = module.vpc.public_subnets[0]

  root_block_device {
    volume_type = "standard"
    volume_size = "20"
  }

  vpc_security_group_ids = [
    aws_security_group.bastion.id,
  ]

  tags = {
    "Name" = "Bastion"
  }
}
