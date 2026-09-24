resource "aws_elasticsearch_domain" "pass" {
  domain_name           = "my-domain"
  elasticsearch_version = "7.10"

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.example.arn
    log_type                 = "AUDIT_LOGS"
    enabled                  = true
  }
}
