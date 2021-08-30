resource "aws_ebs_volume" "negative1" {
  availability_zone = "us-west-2a"
  size              = 40
  encrypted         = true

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_ebs_snapshot" "negative1" {
  volume_id = aws_ebs_volume.negative1.id
  tags {
    Name = "Production"
  }
}
