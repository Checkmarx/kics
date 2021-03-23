resource "aws_ebs_snapshot" "positive1" {
  volume_id = data.aws_ebs_volume.prod_volume.id
  encrypted = false
  tags {
    Name = "Production"
  }
}

resource "aws_ebs_snapshot" "positive2" {
  volume_id = data.aws_ebs_volume.prod_volume.id
  tags {
    Name = "Production"
  }
}