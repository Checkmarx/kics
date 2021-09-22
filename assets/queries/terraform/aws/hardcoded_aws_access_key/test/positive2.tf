resource "aws_instance" "positive1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  user_data = "1234567890123456789012345678901234567890$"
  tags = {
    Name = "HelloWorld"
  }
}

