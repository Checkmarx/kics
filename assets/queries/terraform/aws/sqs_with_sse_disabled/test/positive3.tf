resource "aws_sqs_queue" "positive3" {
  name                              = "terraform-example-queue"
  kms_master_key_id                 = null
  kms_data_key_reuse_period_seconds = 300
}
