resource "google_sql_database_instance" "private_network" {

  name   = "private-instance-1"
  database_version = "POSTGRES_11"
  settings {
    ip_configuration {
      ipv4_enabled = false
      private_network = "some_private_network"
    }
  }
}

resource "google_sql_database_instance" "authorized_networks" {
  name             = "postgres-instance-2"
  database_version = "POSTGRES_11"

  settings {
    tier = "db-f1-micro"

    ip_configuration {

      dynamic "authorized_networks" {

        content {
          name  = "some_trusted_network"
          value = "some_trusted_network_address"
        }
      }

      dynamic "authorized_networks" {

        content {
          name  = "another_trusted_network"
          value = "another_trusted_network_address"
        }
      }
    }
  }
}