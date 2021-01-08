resource "aws_cloudformation_stack" "network" {

     name = "networking-stack"

     parameters = {
     VPCCidr = "10.0.0.0/16"
     }

     template_url = ""
}



resource "aws_cloudformation_stack" "network2" {

     name = "networking-stack"

     parameters = {
     VPCCidr = "10.0.0.0/16"
     }

     template_body = ""
}