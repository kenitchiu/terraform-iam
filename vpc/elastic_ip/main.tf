provider "aws" {
  region = var.aws_region
}

resource "aws_eip" "this" {
  count = length(var.services)
  vpc   = true
  tags = {
    Name = var.services[count.index]
  }
}