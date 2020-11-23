resource "aws_ami_launch_permission" "example" {

  image_id   = "ami-1235678"
  account_id = "12345600012"

}


resource "aws_ami_launch_permission" "example2" {

  image_id   = "ami-1235678"
  account_id = "123456789012"

}