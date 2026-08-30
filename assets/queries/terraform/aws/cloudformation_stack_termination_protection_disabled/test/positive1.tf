resource "aws_cloudformation_stack" "fail" {
  name          = "my-stack"
  template_body = file("template.yaml")
  termination_protection = false
}
