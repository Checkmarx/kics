resource "aws_elasticsearch_domain" "negative1" {
  domain_name           = "example"
  elasticsearch_version = "1.5"

  cluster_config {
    instance_type = "r4.large.elasticsearch"
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  node_to_node_encryption {
    enabled = true
  }

  tags = {
    Domain = "TestDomain"
  }
}
