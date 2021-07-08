variable "aws_region" {
  type        = string
  description = ""
}

variable "central_account_id" {
  type        = string
  description = ""
}

variable "account_alias" {
  type        = string
  description = ""
}

variable "MFAge" {
  type        = string
  description = ""
}

variable "read_account_name" {
  type        = string
  description = ""
}

variable "write_account_name" {
  type        = string
  description = ""
}

variable "robot_account_name" {
  type        = string
  description = ""
}

variable "read_policies" {
  type = list(object({
    actions = list(string)
    resources = list(string)
  }))
}

variable "write_policies" {
  type = list(object({
    actions = list(string)
    resources = list(string)
  }))
}