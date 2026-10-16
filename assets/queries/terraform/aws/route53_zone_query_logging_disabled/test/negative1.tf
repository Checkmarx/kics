resource "aws_route53_zone" "pass" {
  name = "example.com"
}

resource "aws_route53_query_log" "pass" {
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.dns.arn
  zone_id                  = aws_route53_zone.pass.zone_id
}
