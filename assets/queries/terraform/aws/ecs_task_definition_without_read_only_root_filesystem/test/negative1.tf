resource "aws_ecs_task_definition" "pass" {
  family = "my-task"
  container_definitions = jsonencode([{
    name                   = "my-container"
    image                  = "nginx:latest"
    essential              = true
    readonlyRootFilesystem = true
  }])
}
