resource "aws_eip" "ok_eip" {
  instance = aws_instance.ec2.id
  domain = ""
}


resource "aws_instance" "ec2" {
  ami               = "ami-21f78e11"
  availability_zone = "us-west-2a"
  instance_type     = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

