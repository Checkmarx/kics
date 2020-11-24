resource "aws_kinesis_firehose_delivery_stream" "example" {
  name        = "${aws_s3_bucket.logs.bucket}-firehose"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = "${aws_kinesis_stream.cloudwatch-logs.arn}"
    role_arn = "${aws_iam_role.firehose_role.arn}"
  }

  server_side_encryption {

    enabled = true
    key_type = "AWS_OWNED_CMK"
  }
}





resource "aws_kinesis_firehose_delivery_stream" "example2" {
  name        = "${aws_s3_bucket.logs.bucket}-firehose"
  destination = "extended_s3"

}



resource "aws_kinesis_firehose_delivery_stream" "example3" {
  name        = "${aws_s3_bucket.logs.bucket}-firehose"
  destination = "extended_s3"


  server_side_encryption {

    enabled = false
  }
}




resource "aws_kinesis_firehose_delivery_stream" "example4" {
  name        = "${aws_s3_bucket.logs.bucket}-firehose"
  destination = "extended_s3"


  server_side_encryption {

    enabled = true
    key_type = "AWS_OWN"
  }
}



resource "aws_kinesis_firehose_delivery_stream" "example5" {
  name        = "${aws_s3_bucket.logs.bucket}-firehose"
  destination = "extended_s3"


  server_side_encryption {

    enabled = true
    key_type = "CUSTOMER_MANAGED_CMK"
  }
}
