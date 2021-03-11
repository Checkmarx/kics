resource "aws_efs_file_system" "positive1" {
  creation_token = "my-product"

  tags = {
    Name = "MyProduct"
  }
}

resource "aws_efs_file_system" "positive2" {
  creation_token = "my-product"
  encrypted = false
  
  tags = {
    Name = "MyProduct"
  }
}