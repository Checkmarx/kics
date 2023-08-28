resource "aws_kms_key" "positive3" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}
