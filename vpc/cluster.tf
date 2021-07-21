locals {
  az_count = length(data.aws_availability_zones.available.zone_ids)
}

resource "aws_subnet" "eks_private" {
  count = length(var.eks_private_subnets)

  vpc_id               = module.vpc.vpc_id
  availability_zone_id = data.aws_availability_zones.available.zone_ids[count.index % local.az_count]
  cidr_block           = var.eks_private_subnets[count.index]

  tags = merge(var.tags, tomap({
    Name   = "EKS Private subnet"
    Access = "Private"
  }))
}

resource "aws_subnet" "eks_public" {
  count = length(var.eks_private_subnets)

  vpc_id                  = module.vpc.vpc_id
  availability_zone_id    = data.aws_availability_zones.available.zone_ids[count.index % local.az_count]
  cidr_block              = var.eks_public_subnets[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, tomap({
    Name   = "EKS Public subnet"
    Access = "Public"
  }))
}


resource "aws_route_table" "eks_public" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc.igw_id
  }

  tags = merge(var.tags, tomap({
    Name   = "${var.vpc_name}-public-eks"
    Access = "Public"
  }))
}

resource "aws_route_table_association" "eks_public" {
  count          = length(var.eks_public_subnets)
  subnet_id      = aws_subnet.eks_public.*.id[count.index]
  route_table_id = aws_route_table.eks_public.id
}

resource "aws_route_table" "eks_private" {
  count  = length(var.eks_private_subnets)
  vpc_id = module.vpc.vpc_id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? tolist(["dummy"]) : tolist([])
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = module.vpc.natgw_ids[count.index % length(module.vpc.natgw_ids)]
    }
  }

  tags = merge(var.tags, tomap({
    Name   = "${var.vpc_name}-private-eks-${count.index}"
    Access = "Private"
  }))
}

resource "aws_route_table_association" "eks_private" {
  count          = length(var.eks_private_subnets)
  subnet_id      = aws_subnet.eks_private.*.id[count.index]
  route_table_id = aws_route_table.eks_private.*.id[count.index]
}
