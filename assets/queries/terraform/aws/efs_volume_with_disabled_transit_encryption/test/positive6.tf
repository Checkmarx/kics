resource "aws_ecs_task_definition" "service_6" {
  family                = "service"
  container_definitions = file("task-definitions/service.json")

  volume {
    name = "docker-storage-1"
  }

  volume {
    name = "docker-storage-2"
  }
}

