resource "aws_ami_launch_permission" "negative1" {
  image_id   = "ami-12345678"
  account_id = "123456789012"
}


resource "aws_ami_launch_permission" "example" {
  image_id   = "ami-12345680"
  account_id = "12345672"
}
