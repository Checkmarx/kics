# "Generic Token" - baee238e-1921-4801-9c3f-79ae1d7b2cbc - "Avoiding TF creation token"  allow-rule-test
resource "aws_efs_file_system" "example" {
  creation_token = "my-efs-filesystem"  # positive1

  tags = {
    Name = "MyEFS"
  }
}

resource "aws_efs_file_system" "quoted_key" {
  creation_token = "my-efs-token-123"   # positive2
}