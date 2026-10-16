resource "aws_sfn_state_machine" "fail" {
  name     = "my-state-machine"
  role_arn = aws_iam_role.sfn_role.arn
  definition = jsonencode({
    Comment = "My state machine"
    StartAt = "HelloWorld"
    States  = {}
  })

  logging_configuration {
    level = "OFF"
  }
}
