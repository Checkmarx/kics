resource "aws_msk_cluster" "example1" {
  cluster_name           = "example"
  kafka_version          = "2.4.1"
  number_of_broker_nodes = 3
}

resource "aws_msk_cluster" "example2" {
  cluster_name           = "example"
  kafka_version          = "2.4.1"
  number_of_broker_nodes = 3
  
  encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT"
    }
  }
}

resource "aws_msk_cluster" "example3" {
  cluster_name           = "example"
  kafka_version          = "2.4.1"
  number_of_broker_nodes = 3
  
  encryption_info {
    encryption_in_transit {
      in_cluster = false
    }
  }
}

resource "aws_msk_cluster" "example4" {
  cluster_name           = "example"
  kafka_version          = "2.4.1"
  number_of_broker_nodes = 3
  
  encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT"
      in_cluster = false
    }
  }
}