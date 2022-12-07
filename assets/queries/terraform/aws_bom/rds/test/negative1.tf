module "kafka" {
  source = "cloudposse/msk-apache-kafka-cluster/aws"
  version = "0.7.2"

  namespace              = "eg"
  stage                  = "prod"
  name                   = "app"
  vpc_id                 = "vpc-XXXXXXXX"
  zone_id                = "Z14EN2YD427LRQ"
  security_groups        = ["sg-XXXXXXXXX", "sg-YYYYYYYY"]
  subnet_ids             = ["subnet-XXXXXXXXX", "subnet-YYYYYYYY"]
  kafka_version          = "2.4.1"
  number_of_broker_nodes = 2 # this has to be a multiple of the # of subnet_ids
  broker_instance_type   = "kafka.m5.large"
}
