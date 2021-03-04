resource "aws_elasticache_cluster" "multi-az" {
  cluster_id           = "cluster-example"
  engine = "memcached"

  num_cache_nodes = 3

  az_mode = "cross-az"
}