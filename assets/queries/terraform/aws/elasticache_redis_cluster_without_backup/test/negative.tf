resource "aws_elasticache_cluster" "negative1" {
  cluster_id           = "cluster"
  engine               = "redis"
  node_type            = "cache.m5.large"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.default.id

  snapshot_retention_limit = 5
}

resource "aws_elasticache_parameter_group" "default" {
  name   = "cache-params"
  family = "redis2.8"

  parameter {
    name  = "activerehashing"
    value = "yes"
  }

  parameter {
    name  = "min-slaves-to-write"
    value = "2"
  }
}
