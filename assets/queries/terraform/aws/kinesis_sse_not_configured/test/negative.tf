
resource "aws_kinesis_firehose_delivery_stream" "example6" {
  name        = "${aws_s3_bucket.logs.bucket}-firehose"
  destination = "extended_s3"

  server_side_encryption {
    enabled  = true
    key_type = "CUSTOMER_MANAGED_CMK"
    key_arn  = "qwewewre"
  }
}




resource "aws_kinesis_firehose_delivery_stream" "example9" {
  name        = "${aws_s3_bucket.logs.bucket}-firehose"
  destination = "extended_s3"

  server_side_encryption {
    enabled  = true
    key_type = "AWS_OWNED_CMK"
  }
}

