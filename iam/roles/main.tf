# -----------------------------------------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  central_account_id = var.central_account_id == "" ? data.aws_caller_identity.current.account_id : var.central_account_id
}
