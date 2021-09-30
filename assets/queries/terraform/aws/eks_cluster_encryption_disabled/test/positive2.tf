variable "cluster_name" {
  default = "example"
  type    = string
}

resource "aws_eks_cluster" "positive2" {
  depends_on = [aws_cloudwatch_log_group.example]
  name                      = var.cluster_name

  encryption_config {
    resources = ["s"]
    provider {
      key_arn = "test"
    }
  }
}
