provider "aws" {
  region = "us-west-2"
}

resource "aws_elasticsearch_domain" "example" {
  domain_name           = "my-elasticsearch-domain"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t2.small.elasticsearch"
    instance_count = 1
    dedicated_master_enabled = false
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 10
  }

  vpc_options {
    subnet_ids         = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
    security_group_ids = ["sg-xxxxxxxx"]
  }

  domain_endpoint_options {
    enforce_https = true
  }

  tags = {
    Name        = "my-elasticsearch-domain"
    Environment = "production"
  }
}
