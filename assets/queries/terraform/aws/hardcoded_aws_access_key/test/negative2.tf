resource "aws_instance" "negative1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  user_data = file("scripts/first-boot-http.sh")
  tags = {
    Name = "HelloWorld"
  }
}

