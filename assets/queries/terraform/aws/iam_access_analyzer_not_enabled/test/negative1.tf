resource "aws_organizations_organization" "example" {
  aws_service_access_principals = ["access-analyzer.amazonaws.com"]
}

resource "aws_accessanalyzer_analyzer" "example2" {
  depends_on = [aws_organizations_organization.example]

  analyzer_name = "example"
  type          = "ORGANIZATION"
}
