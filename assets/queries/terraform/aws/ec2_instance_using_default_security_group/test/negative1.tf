resource "aws_instance" "negative1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }

  security_groups = [aws_security_group.sg.id]
}
