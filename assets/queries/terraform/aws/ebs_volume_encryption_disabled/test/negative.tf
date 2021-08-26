resource "aws_ebs_volume" "negative1" {
  availability_zone = "us-west-2a"
  size              = 40
  encrypted         = true

  tags = {
    Name = "HelloWorld"
  }
}
