resource "aws_ebs_snapshot" "production_snapshot" {
  volume_id = "${data.aws_ebs_volume.prod_volume.id}"
  encrypted = false
  tags {
    Name = "Production"
  }
}

resource "aws_ebs_snapshot" "production_snapshot2" {
  volume_id = "${data.aws_ebs_volume.prod_volume.id}"
  tags {
    Name = "Production"
  }
}