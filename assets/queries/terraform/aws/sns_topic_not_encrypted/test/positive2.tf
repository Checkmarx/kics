provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "test" {
  name = "sns_not_ecnrypted"
}
