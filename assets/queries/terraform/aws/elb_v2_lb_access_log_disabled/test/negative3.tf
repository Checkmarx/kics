# access_logs written as a list of objects (= [{ ... }]) instead of a block
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "network"

  enable_deletion_protection = true

  access_logs = [{
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }]

  tags = {
    Environment = "production"
  }
}
