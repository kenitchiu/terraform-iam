variable "aws_region" {
  type = string
}

variable "services" {
  type        = list(string)
  description = "Service list which need to be allocated IP."
}