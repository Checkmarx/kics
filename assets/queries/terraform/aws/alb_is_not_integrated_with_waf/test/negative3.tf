resource "aws_lb" "nlb" {
  name               = "test-nlb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [for subnet in aws_subnet.public : subnet.id]
}
