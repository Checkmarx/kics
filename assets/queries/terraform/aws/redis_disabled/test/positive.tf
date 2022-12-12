#this is a problematic code where the query should report a result(s)
resource "aws_elasticache_cluster" "positive1" {
  cluster_id           = "cluster-example"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  engine_version       = "3.2.10"
  port                 = 6379
}
