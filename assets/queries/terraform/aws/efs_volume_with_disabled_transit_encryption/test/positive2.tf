provider "aws" {
  region = "us-west-2"
}

resource "aws_efs_file_system" "example" {
  creation_token      = "example"
  encrypted           = true
  performance_mode    = "generalPurpose"
  throughput_mode     = "bursting"

  tags = {
    Name = "example-efs"
  }
}

resource "aws_efs_mount_target" "example" {
  file_system_id = aws_efs_file_system.example.id
  subnet_id      = "subnet-0123456789abcdef0"
  security_groups = ["sg-0123456789abcdef0"]
}