resource "aws_ebs_snapshot" "production_snapshot" {
  volume_id = "${data.aws_ebs_volume.prod_volume.id}"
  encrypted = true
  tags {
    Name = "Production"
  }
}