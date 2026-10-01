resource "aws_ecs_task_definition" "fail" {
  family = "my-task"
  container_definitions = jsonencode([{
    name      = "my-container"
    image     = "nginx:latest"
    essential = true
    readonlyRootFilesystem = false
  }])
}
