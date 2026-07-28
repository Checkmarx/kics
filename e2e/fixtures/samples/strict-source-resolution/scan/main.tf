// kics_terraform_vars: ../leaked/external.tfvars

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
}
