resource "aws_msk_cluster" "positive1" {
  cluster_name           = "example"
  kafka_version          = "2.7.1"
  number_of_broker_nodes = 3

  broker_node_group_info {
    connectivity_info {
      public_access {
        type = "SERVICE_PROVIDED_EIPS"
      }
    }
    instance_type = "kafka.m5.4xlarge"
    client_subnets = [
      aws_subnet.subnet_az1.id,
      aws_subnet.subnet_az2.id,
      aws_subnet.subnet_az3.id,
    ]
    storage_info {
      ebs_storage_info {
        provisioned_throughput {
          enabled           = true
          volume_throughput = 250
        }
        volume_size = 1000
      }
    }
    security_groups = [aws_security_group.sg.id]
  }
}
