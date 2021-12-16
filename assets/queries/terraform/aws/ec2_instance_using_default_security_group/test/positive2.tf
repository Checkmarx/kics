resource "aws_instance" "positive2" {
  ami = "ami-003634241a8fcdec0"

  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.default.id]
}
