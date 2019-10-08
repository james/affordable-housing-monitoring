
# CloudFront SSL Certificate must be requested in the us-east-1 region
provider "aws" {
  region = "us-east-1"
  alias  = "useast1"

  assume_role {
    role_arn     = "arn:aws:iam::${local.account_id}:role/${var.dalmatian_role}"
    session_name = "dalmatian"
  }
}
