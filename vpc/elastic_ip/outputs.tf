output "ip" {
  description = "The ip address we get."
  value = tomap({
    for i, value in var.services : value => aws_eip.this.*.public_ip[i]
  })
}