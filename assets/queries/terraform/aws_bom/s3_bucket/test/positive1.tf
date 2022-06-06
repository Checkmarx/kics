provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_s3_bucket" "positive1" {
  bucket = "my-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  versioning {
    mfa_delete = true
  }
}

resource "aws_lb_listener" "listener5" {
  load_balancer_arn = aws_lb.test3.arn
  port = 80
  default_action {
    type = "redirect"

    redirect {
      port        = "80"
      protocol    = "HTTP"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb" "test3" {
  name = "test123"
  load_balancer_type = "application"
  subnets = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  internal = true
}
