resource "aws_api_gateway_deployment" "example4" {
  rest_api_id   = "some rest api id"
  stage_name = "some name"
  tags {
    project = "ProjectName"
  }
}

resource "aws_api_gateway_stage" "example0000" {
  deployment_id = aws_api_gateway_deployment.example4.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = "example"

  access_log_settings {
    destination_arn = "dest"
    format = "format"
  }
}
