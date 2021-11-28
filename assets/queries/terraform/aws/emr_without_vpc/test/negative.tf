resource "aws_emr_cluster" "negative1" {
  name          = "emr-test-arn"
  release_label = "emr-4.6.0"
  subnet_id = aws_subnet.main.id
}
