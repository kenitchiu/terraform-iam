variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "ami_id" {
  description = "ID of ami to create server."
  type        = string
  default     = "ami-0827d8ed0295e3feb"
}

variable "instance_type" {
  description = "The EC2 instance type for Jenkins"
  type        = string
}

variable "ebs_size" {
  description = "EBS size"
  type        = number
  default     = 100
}

variable "ssh_public_key" {
  description = "public key to login server via ssh"
  type        = string
}

variable "profile_policies" {
  type = list(object({
    actions   = list(string)
    resources = list(string)
  }))
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "ids of public subnet to launch instance."
}

variable "public_ip" {
  type        = string
  description = "IP address of jenkins service."
}

variable "bastion_sg_id" {
  description = "Security group id of bastion"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "tags to apply to for all gitlab related service."
  default     = {}
}