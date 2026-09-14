# Global allow rule  - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF file function"  allow-rule-test
resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  connection {
    user        = "ubuntu"
    private_key = file(var.private_key_path)  # negative1
  }
}
