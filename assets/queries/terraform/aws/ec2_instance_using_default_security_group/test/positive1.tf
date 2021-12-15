resource "aws_instance" "positive1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }

  security_groups = [aws_security_group.default.id]
}
