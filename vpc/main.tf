provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eip" "nat_gateway_ip" {
  count     = length(var.nat_gateway_ips)
  public_ip = var.nat_gateway_ips[count.index]
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = var.vpc_name
  cidr = var.cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = false

  reuse_nat_ips       = true
  external_nat_ip_ids = data.aws_eip.nat_gateway_ip.*.id

  tags = var.tags
}
