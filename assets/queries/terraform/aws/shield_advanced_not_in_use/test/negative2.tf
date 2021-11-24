resource "aws_route53_zone" "negative2" {
  name = "example.com"
}

resource "aws_shield_protection" "negative2" {
  name         = "example"
  resource_arn = aws_route53_zone.negative2.arn

  tags = {
    Environment = "Dev"
  }
}
