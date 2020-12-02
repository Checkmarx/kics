#this code is a correct code for which the query should not find any result
resource "aws_elasticache_cluster" "negative_example" {
  cluster_id           = "cluster-example"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.4"
  port                 = 11211
}