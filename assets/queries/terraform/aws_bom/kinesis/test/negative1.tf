module "kinesis-stream" {

  source  = "rodrigodelmonte/kinesis-stream/aws"
  version = "v2.0.3"

  name                      = "kinesis_stream_example"
  shard_count               = 1
  retention_period          = 24
  shard_level_metrics       = ["IncomingBytes", "OutgoingBytes"]
  enforce_consumer_deletion = false
  encryption_type           = "KMS"
  kms_key_id                = "alias/aws/kinesis"
  tags                      = {
      Name = "kinesis_stream_example"
  }

}
