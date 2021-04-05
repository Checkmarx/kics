resource "aws_efs_file_system" "negative1" {
  creation_token = "my-product"
  encrypted = true
  
  tags = {
    Name = "MyProduct"
  }
}