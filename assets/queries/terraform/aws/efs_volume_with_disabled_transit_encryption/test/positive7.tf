resource "aws_ecs_task_definition" "service_7" {
  family                = "service"
  container_definitions = file("task-definitions/service.json")

  volume {
    name = "efs-vol-good"

    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.fs1.id
      root_directory          = "/opt/data1"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
      authorization_config {
        access_point_id = aws_efs_access_point.test1.id
        iam             = "ENABLED"
      }
    }
  }

  volume {
    name = "efs-vol-bad"

    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.fs2.id
      root_directory          = "/opt/data2"
      transit_encryption      = "DISABLED"
      transit_encryption_port = 2999
      authorization_config {
        access_point_id = aws_efs_access_point.test2.id
        iam             = "ENABLED"
      }
    }
  }
}

