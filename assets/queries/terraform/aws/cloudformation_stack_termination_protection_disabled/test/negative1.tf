resource "aws_cloudformation_stack" "pass" {
  name                   = "my-stack"
  template_body          = file("template.yaml")
  termination_protection = true
}
