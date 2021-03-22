resource "aws_msk_cluster" "positive1" {
  cluster_name           = "example"
  kafka_version          = "2.4.1"
  number_of_broker_nodes = 3
}

resource "aws_msk_cluster" "positive2" {
  cluster_name           = "example"
  kafka_version          = "2.4.1"
  number_of_broker_nodes = 3
  
  encryption_info {
    encryption_in_transit {
      client_broker = "PLAINTEXT"
    }
  }
}

resource "aws_msk_cluster" "positive3" {
  cluster_name           = "example"
  kafka_version          = "2.4.1"
  number_of_broker_nodes = 3
  
  encryption_info {
    encryption_in_transit {
      in_cluster = false
    }
  }
}

resource "aws_msk_cluster" "positive4" {
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