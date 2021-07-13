output "cluster_name" {
  value = "example"
  type    = string
  description = " "
}

resource "aws_eks_cluster" "positive1" {
  depends_on = [aws_cloudwatch_log_group.example]
}
