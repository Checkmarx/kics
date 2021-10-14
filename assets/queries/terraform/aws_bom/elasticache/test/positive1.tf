resource "aws_elasticache_cluster" "positive1" {
  cluster_id           = "cluster-example"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 2
  parameter_group_name = aws_elasticache_parameter_group.default_1
  port                 = 11211
}

resource "aws_elasticache_parameter_group" "default_1" {
  name   = "cache-params"
  family = "memcached1.4"
}
