resource "aws_security_group" "sg1" {
    name = "sg1"
    description = "sg1"

    ingress {
        from_port = 0
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "sg2" {
    name = "sg2"
    description = "positive3"

    ingress {
        from_port = 0
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_elasticache_security_group" "positive3" {
    name =  "positive3"
    security_group_names = [
        aws_security_group.sg1.name,
        aws_security_group.sg2.name,
    ]
}

resource "aws_elasticache_cluster" "positive3" {
    cluster_id = "test-cache"
    engine = "redis"
    node_type = "cache.t1.micro"
    port = 6379
    num_cache_nodes = 1
    parameter_group_name = "default.redis3.2"
    security_group_names = [aws_elasticache_security_group.positive3.name]
}
