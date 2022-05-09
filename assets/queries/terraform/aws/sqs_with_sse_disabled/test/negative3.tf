resource "aws_sqs_queue" "negative3" {
  name                    = "terraform-example-queue"
  sqs_managed_sse_enabled = true
}
