resource "aws_elasticache_cluster" "negative1" {
  cluster_id           = "cluster-example"
  engine = "memcached"

  num_cache_nodes = 3

  az_mode = "cross-az"
}