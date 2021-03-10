resource "aws_lb" "positive1" {
  # ...
}

resource "aws_lb_target_group" "positive2" {
  # ...
}

resource "aws_lb_listener" "positive3" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "80"
      protocol    = "HTTP"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "positive4" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "8080"
  protocol          = "HTTP"  
}