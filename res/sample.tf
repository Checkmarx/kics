data "template_file" "km_ecs_template" {
  template = file("./modules/compute/task-definitions.json")
  vars = {
    ENVIRONMENT = var.environment
    LOG_GROUP   = aws_cloudwatch_log_group.km_log_group.name
    REGION      = var.region
  }
}

resource "aws_iam_role" "km_ecs_task_execution_role" {
  name = "km_ecs_task_execution_role_${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = merge(var.default_tags, {
    name        = "km_ecs_task_execution_role_${var.environment}"
  })
}

resource "aws_iam_policy" "km_ssm_secrets_policy" {
  name        = "km_ssm_secrets_policy_${var.environment}"
  description = "Kai Monkey SSM Secrets Policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "KaiMonkeySSMSecretsPolicyGet",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "*"
        },
        {
            "Sid": "KaiMonkeySSMSecretsPolicyGetDecrypt",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "ssm:GetParameters",
                "ssm:GetParameter"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "km_ecs_task_exec_role_policy_attach" {
  role       = aws_iam_role.km_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "km_ssm_secrets_policy_policy_attach" {
  role       = aws_iam_role.km_ecs_task_execution_role.name
  policy_arn = aws_iam_policy.km_ssm_secrets_policy.arn
}

resource "aws_ecs_cluster" "km_ecs_cluster" {
  name = "km_ecs_cluster-${var.environment}"

  tags = merge(var.default_tags, {
    Name = "km_ecs_cluster_${var.environment}"
  })
}

resource "aws_ecs_task_definition" "km_ecs_task" {
  family                   = "km_ecs_task_${var.environment}"
  container_definitions    = data.template_file.km_ecs_template.rendered
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.km_ecs_task_execution_role.arn
  tags = merge(var.default_tags, {
    Name = "km_ecs_task_${var.environment}"
  })
}

resource "aws_ecs_service" "km_ecs_service" {
  name            = "km_ecs_service_${var.environment}"
  cluster         = aws_ecs_cluster.km_ecs_cluster.id
  task_definition = aws_ecs_task_definition.km_ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.elb_target_group_arn
    container_name   = "km-frontend"
    container_port   = 80
  }
  network_configuration {
    assign_public_ip = true
    subnets          = var.private_subnet
    security_groups  = [ var.elb_sg ]
  }
  tags = merge(var.default_tags, {
  })
}

resource "aws_cloudwatch_log_group" "km_log_group" {
  name              = "km_log_group_${var.environment}"
  retention_in_days = 1

  tags = merge(var.default_tags, {
    Name = "km_log_group_${var.environment}"
  })
}

resource "aws_instance" "km_vm"{
  ami = data.aws_ami.ubuntu_ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [ var.elb_sg ]
  subnet_id = var.public_subnet[0]
  tags = merge(var.default_tags, {
    Name = "km_vm_${var.environment}"
  })
}
