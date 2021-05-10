resource "aws_config_configuration_aggregator" "positive1" {
  name = "example"

  account_aggregation_source {
    account_ids = ["123456789012"]
    regions     = ["us-east-2", "us-east-1", "us-west-1", "us-west-2"]
  }
}

resource "aws_config_configuration_aggregator" "positive2" {
  depends_on = [aws_iam_role_policy_attachment.organization]

  name = "example" # Required

  organization_aggregation_source {
    all_regions = false
    role_arn    = aws_iam_role.organization.arn
  }
}
