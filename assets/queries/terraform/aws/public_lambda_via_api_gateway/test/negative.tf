resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/test/test"
}

resource "aws_lambda_function" "example" {
  function_name = "ServerlessPerson"

  handler = "MyHandler::handleRequest"
  runtime = "java11"

  role = aws_iam_role.lambda_exec.arn
}

