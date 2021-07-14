variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "human_accounts" {
  type        = list(any)
  description = "list of human account"
}

variable "robot_account_name" {
  type = string
}

variable "human_group_name" {
  type = string
}

variable "read_group_name" {
  type    = string
  default = "read"
}

variable "write_group_name" {
  type    = string
  default = "write"
}

variable "robot_group_name" {
  type    = string
  default = "robot"
}

variable "read_role_name" {
  type        = string
  description = ""
  default     = "read_role"
}

variable "write_role_name" {
  type        = string
  description = ""
  default     = "write_role"
}

variable "robot_role_name" {
  type        = string
  description = ""
  default     = "robot_role"
}

variable "account_id_mapping" {
  type        = map(any)
  description = "aws account alias and id"
}