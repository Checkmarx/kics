resource "aws_organizations_organization" "positive1" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  feature_set = "CONSOLIDATED_BILLING"
}
