resource "aws_ecs_service" "positive1" {
  name    = "positive1"
  cluster = aws_ecs_cluster.example.id
  desired_count   = 0
}
