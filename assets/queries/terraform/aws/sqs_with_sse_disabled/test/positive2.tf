resource "aws_sqs_queue" "positive2" {
  name                              = "terraform-example-queue"
  kms_master_key_id                 = ""
  kms_data_key_reuse_period_seconds = 300
}

