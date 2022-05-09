resource "aws_mq_broker" "positive2" {
  broker_name = "example"

  configuration {
    id       = aws_mq_configuration.test.id
    revision = aws_mq_configuration.test.latest_revision
  }

  engine_type        = "RabbitMQ"
  engine_version     = "5.15.9"
  host_instance_type = "mq.t2.micro"
  security_groups    = [aws_security_group.test.id]

  user {
    username = "ExampleUser"
    password = "111111111111"
  }

   user {
    username = "ExampleUser"
    password = "MindTheGap"
  }

  encryption_options {
    kms_key_id = var.encryption_options.kms_key_id
  }
}
