resource "aws_elasticache_cluster" "positive1" {
  cluster_id           = "cluster"
  engine               = "redis"
  node_type            = "cache.m5.large"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.default.id
}
