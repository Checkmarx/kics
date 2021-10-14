variable "web_type" {
  description = "Size/type of the host."
  default     = "m5.large"
}

module "ebs_optimized" {
  source        = "terraform-aws-modules/ebs-optimized/aws"
  version = "~> 2.0"
  instance_type = var.web_type
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.web_type
  ebs_optimized = module.ebs_optimized.answer
}
