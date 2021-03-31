resource "aws_ecs_service" "negative1" {
  name    = "negative1"
  cluster = aws_ecs_cluster.example.id

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
}
