resource "aws_ecs_task_definition" "fargate_efs_disabled" {
  family                   = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions    = file("task-definitions/service.json")

  volume {
    name = "efs-storage"

    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.fs.id
      root_directory          = "/opt/data"
      transit_encryption      = "DISABLED"
      transit_encryption_port = 2999
    }
  }
}
