resource "aws_cloudwatch_event_bus_policy" "fail" {
  event_bus_name = aws_cloudwatch_event_bus.main.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowAll"
      Effect    = "Allow"
      Principal = "*"
      Action    = "events:PutEvents"
      Resource  = aws_cloudwatch_event_bus.main.arn
    }]
  })
}
