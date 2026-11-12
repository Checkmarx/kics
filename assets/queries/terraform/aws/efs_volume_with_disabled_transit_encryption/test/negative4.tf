resource "aws_ecs_task_definition" "fargate_multi_local" {
  family                   = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions    = file("task-definitions/service.json")

  volume {
    name = "local-storage-1"
  }

  volume {
    name = "local-storage-2"
  }
}
