resource "aws_ecs_service" "example_ecs_service" {
  name            = "example_service"
  cluster         = aws_ecs_cluster.example_cluster.id
  task_definition = aws_ecs_task_definition.example_task.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:region:123456789012:targetgroup/example/abcdef123456"
    container_name   = "example"
    container_port   = 8080
  }

  tags = {
    Environment = "prod"
  }
}
