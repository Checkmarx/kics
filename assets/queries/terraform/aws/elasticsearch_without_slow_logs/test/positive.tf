resource "aws_elasticsearch_domain" "example" {

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.example.arn
    log_type                 = "INDEX_SLOW_LOGS"
    enabled = false
  }
}

resource "aws_elasticsearch_domain" "example2" {

log_publishing_options {
cloudwatch_log_group_arn = aws_cloudwatch_log_group.example.arn
log_type = "ES_APPLICATION_LOGS"
enabled = true
}
}