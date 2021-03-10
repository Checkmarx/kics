resource "aws_efs_file_system" "positive1" {
  creation_token = "my-product"
  encrypted = true

  tags = {
    Name = "MyProduct"
  }
}