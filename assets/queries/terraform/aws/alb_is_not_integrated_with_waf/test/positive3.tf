resource "aws_lb" "alb" {
  name        = "test-lb-tf"
  internal    = false
  subnets     = [aws_subnet.public1.id, aws_subnet.public2.id]
}
