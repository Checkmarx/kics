resource "aws_elasticache_cluster" "positive1" {
  cluster_id = "cluster-example"
  engine = "memcached"
  num_cache_nodes = 3
}

resource "aws_elasticache_cluster" "positive2" {
  cluster_id = "cluster-example"
  engine = "memcached"
  num_cache_nodes = 3

  az_mode = "single-az"
}