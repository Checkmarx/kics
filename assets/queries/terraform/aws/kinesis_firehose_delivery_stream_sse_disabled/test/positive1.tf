resource "aws_kinesis_firehose_delivery_stream" "fail" {
  name        = "my-firehose"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = aws_s3_bucket.dest.arn
  }

  server_side_encryption {
    enabled = false
  }
}
