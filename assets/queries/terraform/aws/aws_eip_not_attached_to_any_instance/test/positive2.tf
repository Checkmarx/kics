resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

resource "aws_eip" "web_eip" {}

resource "aws_eip_association" "web_eip_assoc" {
  instance_id   = aws_instance.web2.id
  allocation_id = aws_eip.web_eip.id
}
