resource "aws_alb" "nlb" {
  name               = "test-nlb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
}
