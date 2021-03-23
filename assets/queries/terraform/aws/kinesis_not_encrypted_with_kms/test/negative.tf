resource "aws_kinesis_stream" "negative1" {
  name             = "terraform-kinesis-test"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags = {
    Environment = "test"
  }


  encryption_type = "KMS"

  kms_key_id = "alias/aws/kinesis"
}

