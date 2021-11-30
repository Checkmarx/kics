resource "aws_route53_zone" "positive2" {
  name = "example.com"
}

resource "aws_shield_protection" "positive2" {
  name         = "example"
  resource_arn = aws_route53_zone.positive.arn

  tags = {
    Environment = "Dev"
  }
}
