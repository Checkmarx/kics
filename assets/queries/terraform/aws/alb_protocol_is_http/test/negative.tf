## trigger validator
resource "aws_lb" "negative1" {
  # ...
}

resource "aws_lb_target_group" "negative2" {
  # ...
}

resource "aws_lb_listener" "negative3" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "negative4" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "443"
  protocol          = "HTTPS"
}
