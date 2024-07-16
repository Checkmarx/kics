resource "aws_security_group" "example" {
  name        = "example"
  description = "Allow Redis traffic"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = "Example"
  parameter_group_name       = "default.redis6.x"
  engine                     = "redis"
  engine_version             = "6.x"
  automatic_failover_enabled = false

  security_group_ids = [aws_security_group.example.id]
}