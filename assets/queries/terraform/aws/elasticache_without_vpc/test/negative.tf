resource "aws_elasticache_cluster" "negative1" {
  cluster_id           = "cluster-example"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 2
  parameter_group_name = aws_elasticache_parameter_group.default.id
  port                 = 11211
  subnet_group_name    = var.subnet_group_name
}
