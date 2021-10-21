resource "aws_elasticache_cluster" "positive2" {
  cluster_id           = "cluster-example"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.default_2
  engine_version       = "3.2.10"
  port                 = 6379
}

resource "aws_elasticache_parameter_group" "default_2" {
  name   = "cache-params"
  family = "redis3.2"
}
