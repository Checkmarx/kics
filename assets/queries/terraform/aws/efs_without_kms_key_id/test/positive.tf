resource "aws_efs_file_system" "foo3" {
  creation_token = "my-product"
  encrypted = true

  tags = {
    Name = "MyProduct"
  }
}