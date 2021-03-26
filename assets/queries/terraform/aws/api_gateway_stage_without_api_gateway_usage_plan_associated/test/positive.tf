resource "aws_api_gateway_stage" "positive1" {
  rest_api_id   = "some deployment id"
  deployment_id = "some rest api id"
  stage_name = "some name"
  tags {
    project = "ProjectName"
  }
}

resource "aws_api_gateway_stage" "positive2" {
  deployment_id = "some deployment id"
  rest_api_id   = "some rest api id"
  stage_name    = "development"
}

resource "aws_api_gateway_usage_plan" "positive3" {
  name         = "my-usage-plan"
  description  = "my description"
  product_code = "MYCODE"

  api_stages {
    api_id = "another id"
    stage  = "development"
  }
}
