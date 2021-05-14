resource "aws_lb_listener" "listener55" {
  load_balancer_arn = aws_lb.test33.arn
  port = 80
  default_action {
    type = "redirect"

    redirect {
      port        = "80"
      protocol    = "HTTPS"
      status_code = "HTTPS_301"
    }
  }
}

resource "aws_lb" "test33" {
  name = "test123"
  load_balancer_type = "application"
  subnets = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  internal = true
}
