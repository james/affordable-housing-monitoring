resource "aws_kms_key" "ssm" {
  description             = "SSM key ${terraform.workspace} ${local.app_name}"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "ssm" {
  name          = "alias/ssm-${terraform.workspace}-${local.app_name}"
  target_key_id = "${aws_kms_key.ssm.key_id}"
}
