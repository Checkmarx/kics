variable "cluster_name" {
  default = "example"
  type    = " "
  description = "test"
}

resource "aws_eks_cluster" "positive1" {
  depends_on = [aws_cloudwatch_log_group.example]
  name                      = var.cluster_name
}
