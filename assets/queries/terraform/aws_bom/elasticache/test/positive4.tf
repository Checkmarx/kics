resource "aws_security_group" "sg11" {
    name = "sg1"
    description = "sg11"

    ingress {
        from_port = 0
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.2.0/0"]
    }
}

resource "aws_security_group" "sg22" {
    name = "sg22"
    description = "positive3"

    ingress {
        from_port = 0
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.2.0/0"]
    }
}

resource "aws_elasticache_security_group" "positive4" {
    name =  "positive4"
    security_group_names = [
        aws_security_group.sg11.name,
        aws_security_group.sg22.name,
    ]
}

resource "aws_elasticache_cluster" "positive4" {
    cluster_id = "test-cache"
    engine = "redis"
    node_type = "cache.m4.large"
    port = 6379
    num_cache_nodes = 1
    parameter_group_name = aws_elasticache_parameter_group.default.id
    security_group_names = [aws_elasticache_security_group.positive4.name]
}
