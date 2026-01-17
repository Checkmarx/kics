locals {
  resource_name = "${var.resource_prefix}${var.name}"
  environment   = "production"
}

resource "kubernetes_service_v1" "example" {
  metadata {
    name      = "my-service"
    namespace = "default"
    labels = {
      app = local.resource_name
    }
  }

  spec {
    selector = {
      app = local.resource_name
    }

    port {
      port        = 80
      target_port = 8080
    }
  }
}

resource "aws_s3_bucket" "example" {
  bucket = local.resource_name
  
  tags = {
    Name        = local.resource_name
    Environment = local.environment
  }
}

