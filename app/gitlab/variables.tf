variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "gitlab_instance_type" {
  description = "The EC2 instance type for gitab"
  type        = string
}

variable "postgres_instance_type" {
  description = "The instance type for postgres"
  type        = string
}

variable "redis_instance_type" {
  description = "The AWS instance type for redis"
  type        = string
}

variable "gitlab_ami" {
  description = "ID of ami used create gitlab server."
  type        = string
  default     = "ami-0827d8ed0295e3feb"
}

variable "gitlab_ebs_size" {
  description = "EBS size of gitlab"
  type        = number
  default     = 100
}

variable "s3_bucket_prefix" {
  description = "Prefix of s3 bucket"
  type        = string
  default     = "gl"
}
variable "s3_bucket_list" {
  type        = list(string)
  description = "list of s3 bucket name for gitlab."
}

variable "tags" {
  type        = map(string)
  description = "tags to apply to for all gitlab related service."
  default     = {}
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "ids of public subnet to launch gitlab instance."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "ids of private subnet to launch gitlab db."
}

variable "public_ip" {
  type        = string
  description = "IP address of gitlab service."
}

variable "db_storage_size" {
  description = "Storage size of postgres"
  type        = number
}

variable "db_username" {
  description = "username of postgres"
  type        = string
}

variable "db_password" {
  description = "password of postgres"
  type        = string
}

variable "gitlab_public_key" {
  description = "public ssh key to login gitlab server"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security group id of bastion"
  type        = string
}