resource "aws_cloudwatch_event_bus_policy" "pass" {
  event_bus_name = aws_cloudwatch_event_bus.main.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AllowSpecificAccount"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::123456789012:root"
      }
      Action   = "events:PutEvents"
      Resource = aws_cloudwatch_event_bus.main.arn
    }]
  })
}
