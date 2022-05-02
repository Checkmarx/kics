resource "aws_organizations_organization" "example2" {
  aws_service_access_principals = ["access-analyzer.amazonaws.com"]
}
