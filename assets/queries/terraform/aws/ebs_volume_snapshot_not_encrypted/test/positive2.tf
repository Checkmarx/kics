resource "aws_ebs_volume" "positive2" {
  availability_zone = "us-west-2a"
  size              = 40

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_ebs_snapshot" "positive2" {
  volume_id = aws_ebs_volume.positive2.id
  tags {
    Name = "Production"
  }
}
