variable "cluster_name" {
  default = "example"
  type    = string
}

resource "aws_eks_cluster" "negative1" {
  depends_on = [aws_cloudwatch_log_group.example]
  name                      = var.cluster_name

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = "test"
    }
  }
}
