variable "default" {
    type    = "string"
    default = "default_var_file"
}

data "aws_ami" "example" {
	most_recent = true
  
	owners = ["self"]
	tags = {
	  Name   = "app-server"
	  Tested = "true"
	  ("Tag/${var.default}") = "test"
	}
}
