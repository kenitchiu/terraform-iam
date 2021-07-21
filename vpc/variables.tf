variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "default"
}

variable "cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
}

variable "eks_private_subnets" {
  description = "value"
  type        = list(string)
  default     = []
}

variable "eks_public_subnets" {
  description = "value"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Enable net gateway or not"
  type        = bool
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
}

variable "tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    Terraform = "true"
  }
}

variable "public_subnet_tags" {
  description = "Tags to apply to public subnets"
  type = map(string)
  default = {
    "Access" = "Public"
  }
}

variable "private_subnet_tags" {
  description = "Tags to apply to private subnets"
  type = map(string)
  default = {
    "Access" = "Private"
  }
}

variable "bastion_instance_type" {
  description = "The AWS instance type for bastion"
  type        = string
  default     = "t2.micro"
}

variable "bastion_ami" {
  description = "ID of ami used create bastion server."
  type        = string
  default     = "ami-0827d8ed0295e3feb"
}

variable "bastion_public_key" {
  description = "public ssh key to login bastion server"
  type        = string
}

variable "nat_gateway_ips" {
  description = "IP list to assigned to NAT gateway."
  type        = list(string)
  default     = []
}