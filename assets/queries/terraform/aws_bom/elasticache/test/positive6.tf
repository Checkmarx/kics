resource "aws_security_group" "sg6" {
    name = "sg6"
    description = "sg6"

    ingress {
        from_port = 0
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_elasticache_cluster" "positive6" {
    cluster_id = "test-cache"
    engine = "redis"
    node_type = "cache.m4.large"
    port = 6379
    num_cache_nodes = 1
    parameter_group_name = aws_elasticache_parameter_group.default.id
     security_group_ids = [aws_security_group.sg6.id]
}
