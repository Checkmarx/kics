resource "aws_sfn_state_machine" "pass" {
  name     = "my-state-machine"
  role_arn = aws_iam_role.sfn_role.arn
  definition = jsonencode({
    Comment = "My state machine"
    StartAt = "HelloWorld"
    States  = {}
  })

  logging_configuration {
    level                  = "ALL"
    include_execution_data = true
    log_destination        = "${aws_cloudwatch_log_group.sfn.arn}:*"
  }
}
