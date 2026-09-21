resource "aws_eip" "eip_example" {
  instance = aws_instance.example1.id
  domain = "vpc"
}

resource "aws_instance" "example" {
  ami               = "ami-21f78e11"
  availability_zone = "us-west-2a"
  instance_type     = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}