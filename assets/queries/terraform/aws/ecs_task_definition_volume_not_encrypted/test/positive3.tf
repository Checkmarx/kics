resource "aws_ecs_task_definition" "service_2" {
  family                = "service"
  container_definitions = file("task-definitions/service.json")

  volume {
    name = "service-storage"
  }
}
