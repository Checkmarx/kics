resource "aws_cloudformation_stack_set_instance" "negative1" {
  account_id     = "123456789012"
  region         = "us-east-1"
  stack_set_name = aws_cloudformation_stack_set.example.name
  retain_stack     = true
}