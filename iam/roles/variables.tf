variable "aws_region" {
  type        = string
  description = ""
  default     = "ap-northeast-1"
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

variable "read_policies" {
  type = list(object({
    actions   = list(string)
    resources = list(string)
  }))
}

variable "write_policies" {
  type = list(object({
    actions   = list(string)
    resources = list(string)
  }))
}

variable "robot_policies" {
  type = list(object({
    actions   = list(string)
    resources = list(string)
  }))

  default = [{
    actions   = ["*"]
    resources = ["*"]
  }]
}