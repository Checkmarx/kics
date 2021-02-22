resource "aws_elasticache_cluster" "no-az-specified" {
  cluster_id = "cluster-example"
  engine = "memcached"
  num_cache_nodes = 3
}

resource "aws_elasticache_cluster" "single-az" {
  cluster_id = "cluster-example"
  engine = "memcached"
  num_cache_nodes = 3

  az_mode = "single-az"
}