resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  connection {
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  }
}
