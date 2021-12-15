resource "aws_emr_cluster" "positive1" {
  name          = "emr-test-arn"
  release_label = "emr-4.6.0"
}
