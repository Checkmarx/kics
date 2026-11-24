# access_logs as a list with logging explicitly disabled - still a finding
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "network"

  enable_deletion_protection = true

  access_logs = [{
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = false
  }]

  tags = {
    Environment = "production"
  }
}
