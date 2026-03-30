# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding next_token Var"  allow-rule-test
resource "aws_lambda_function" "list_resources" {
  function_name = "list-all-resources"
  runtime       = "python3.12"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_role.arn
  filename      = "lambda.zip"
}

resource "local_file" "lambda_code" {
  filename = "index.py"
  content  = <<EOF
import boto3
ec2 = boto3.client('ec2')
def handler(event, context):
    next_token = event.get('NextToken', None)
    params = {'MaxResults': 100}
    if next_token:
        params['NextToken'] = next_token
    response = ec2.describe_instances(**params)
    return {'NextToken': response.get('NextToken')}
EOF
}