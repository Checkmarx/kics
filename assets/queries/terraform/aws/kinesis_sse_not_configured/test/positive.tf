resource "aws_kinesis_firehose_delivery_stream" "positive1" {
  name        = "${aws_s3_bucket.logs.bucket}-firehose"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.cloudwatch-logs.arn
    role_arn           = aws_iam_role.firehose_role.arn
  }
}


resource "aws_kinesis_firehose_delivery_stream" "positive2" {
  name        = "${aws_s3_bucket.logs.bucket}-firehose"
  destination = "extended_s3"
}


resource "aws_kinesis_firehose_delivery_stream" "positive3" {
  name        = "${aws_s3_bucket.logs.bucket}-firehose"
  destination = "extended_s3"

  server_side_encryption {
    enabled = false
  }
}


resource "aws_kinesis_firehose_delivery_stream" "positive4" {
  name        = "${aws_s3_bucket.logs.bucket}-firehose"
  destination = "extended_s3"

  server_side_encryption {
    enabled  = true
    key_type = "AWS_OWN"
  }
}

resource "aws_kinesis_firehose_delivery_stream" "positive5" {
  name        = "${aws_s3_bucket.logs.bucket}-firehose"
  destination = "extended_s3"

  server_side_encryption {
    enabled  = true
    key_type = "CUSTOMER_MANAGED_CMK"
  }
}
