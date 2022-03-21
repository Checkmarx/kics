resource "aws_sqs_queue" "positive7" {
  name                    = "terraform-example-queue"
  sqs_managed_sse_enabled = false
}
