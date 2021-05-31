provider "aws" {
  region = "us-east-1"
}

resource "aws_efs_file_system" "not_secure" {
  creation_token = "efs-not-secure"

  tags = {
    Name = "NotSecure"
  }
}

resource "aws_efs_file_system_policy" "not_secure_policy" {
  file_system_id = aws_efs_file_system.not_secure.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "ExamplePolicy01",
    "Statement": [
        {
            "Sid": "ExampleStatement01",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "elasticfilesystem:*"
            ]
        }
    ]
}
POLICY
}
