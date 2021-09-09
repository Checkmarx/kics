resource "aws_alb" "positive2" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = aws_subnet.public.*.id


  tags = {
    Environment = "production"
  }
}
