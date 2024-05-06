resource "aws_route53_zone" "no_query_log" {
  name = "example.com"
}

resource "aws_route53_zone" "log_group_mismatch" {
  name = "example.com"
}

resource "aws_route53_query_log" "log_group_mismatch" {
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.aws_route53_log_mismatch.arn
}