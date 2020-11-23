resource "aws_efs_file_system" "foo2" {
  creation_token = "my-product"
  encrypted = true
  kms_key_id = "1234abcd-12ab-34cd-56ef-1234567890ab"

  tags = {
    Name = "MyProduct"
  }
}