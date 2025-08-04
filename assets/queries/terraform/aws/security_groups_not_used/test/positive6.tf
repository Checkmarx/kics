resource "aws_security_group" "default_name" {
  name        = "default_name"
}

resource "aws_lb" "test" {
  name = "test"
  load_balancer_type = "application"
  subnets = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  internal = true
  security_groups = [aws_security_group.default_name_to_prevent_prefix_False_Negative.id]
}