resource "aws_lb" "front_end" {
  # ...
}

resource "aws_lb_target_group" "front_end" {
  # ...
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "80"
  protocol          = "HTTP" //IncorrectValue:"group=rule1,upper,resource=['aws_lb_listener','aws_alb_listener']"

  default_action {
    type = "redirect"

    redirect {
      port        = "80"
      protocol    = "HTTP" //IncorrectValue:"group=rule1,upper,condition=!=,val=HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "8080"
  protocol          = "HTTP" //IncorrectValue:"group=rule2,upper,resource=['aws_lb_listener','aws_alb_listener']"

  default_action {
    redirect {
      protocol = "any" //MissingAttribute:"group=rule2"
    }
  }
}