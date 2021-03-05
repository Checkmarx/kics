resource "aws_ebs_snapshot" "negative1" {
  volume_id = "${data.aws_ebs_volume.prod_volume.id}"
  encrypted = true
  tags {
    Name = "Production"
  }
}