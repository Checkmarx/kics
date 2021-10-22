resource "aws_security_group" "sgg" {
    name = "sgg"
    description = "sgg"

    ingress {
        from_port = 0
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.2.0/0"]
    }
}

resource "aws_elasticache_cluster" "positive5" {
    cluster_id = "test-cache"
    engine = "redis"
    node_type = "cache.m4.large"
    port = 6379
    num_cache_nodes = 1
    parameter_group_name = aws_elasticache_parameter_group.default.id
    security_group_names = [aws_security_group.sgg.name]
}
