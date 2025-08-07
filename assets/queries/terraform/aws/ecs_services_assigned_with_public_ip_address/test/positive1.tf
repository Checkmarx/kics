resource "aws_ecs_service" "example_ecs_service" {
  name            = "example_service_dev"
  cluster         = aws_ecs_cluster.example_cluster.id
  task_definition = aws_ecs_task_definition.example_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = "arn:aws:elasticloadbalancing:region:123456789012:targetgroup/example-group/abcdef123456"
    container_name   = "example-container"
    container_port   = 8080
  }

  network_configuration {
    assign_public_ip = true
    subnets          = ["subnet-abc123", "subnet-def456"]
    security_groups  = ["sg-0123456789abcdef0"]
  }

  tags = {
    Environment = "dev"
    Owner       = "test_user"
  }
}
