resource "aws_msk_cluster" "example1" {  
  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = false
        log_group = aws_cloudwatch_log_group.test.name
      }
      firehose {
        delivery_stream = aws_kinesis_firehose_delivery_stream.test_stream.name
      }
      s3 {
        enabled = true
        bucket  = aws_s3_bucket.bucket.id
        prefix  = "logs/msk-"
      }
    }
  }
}

resource "aws_msk_cluster" "example2" {  
  
}