resource "aws_api_gateway_deployment" "negative1" {
  rest_api_id   = "rest_api_1"
  stage_name    = "development"
}

resource "aws_api_gateway_usage_plan" "negative2" {
  name         = "my-usage-plan"
  description  = "my description"
  product_code = "MYCODE"

  api_stages {
    api_id = "rest_api_1"
    stage  = "development"
  }

  api_stages {
    api_id = "rest_api_2"
    stage  = "development_2"
  }
}
