data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_eip" "positive1" {
  vpc = true
}

resource "aws_shield_protection" "positive1" {
  name         = "example"
  resource_arn = "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:eip-allocation/${aws_eip.positive.id}"

  tags = {
    Environment = "Dev"
  }
}
