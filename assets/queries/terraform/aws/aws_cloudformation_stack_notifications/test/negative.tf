resource "aws_cloudformation_stack" "network" {

  name = "networking-stack"

  parameters = {
    VPCCidr = "10.0.0.0/16"
  }


  notification_arns = ["a","b"]

}