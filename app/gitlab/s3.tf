resource "aws_s3_bucket" "gitlab" {
  count  = length(var.s3_bucket_list)
  bucket = "${var.s3_bucket_prefix}-${var.s3_bucket_list[count.index]}"
  acl    = "private"

  tags = merge(var.tags, tomap({
    "Name" = "Gitlab S3"
  }))
}