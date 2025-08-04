resource "google_sql_database_instance" "negative1" {

  name   = "private-instance-1"
  database_version = "POSTGRES_11"
  settings {
    ip_configuration {
      ipv4_enabled = false
      private_network = "some_private_network"
    }
  }
}

resource "google_sql_database_instance" "negative2" {
  name             = "postgres-instance-2"
  database_version = "POSTGRES_11"

  settings {
    tier = "db-f1-micro"

    ip_configuration {

      authorized_networks {

        content {
          name  = "some_trusted_network"
          value = "some_trusted_network_address"
        }
      }

      authorized_networks {

        content {
          name  = "another_trusted_network"
          value = "another_trusted_network_address"
        }
      }
    }
  }
}

resource "google_sql_database_instance" "negative3" {
  provider             = google-beta

  settings {

    dynamic "ip_configuration" {
      for_each = var.ip_configuration == null ? [] : [true]
      content {
        ipv4_enabled                                  = false
        private_network                               = "some_private_network"
      }
    }
  }
}

resource "google_sql_database_instance" "negative4" {
  provider             = google-beta

  settings {

    dynamic "ip_configuration" {
      for_each = var.ip_configuration == null ? [] : [true]
      content {
        
        dynamic "authorized_networks" {
          for_each = var.ip_configuration.authorized_networks != null ? var.ip_configuration.authorized_networks : []
          content {
            name  = "some_trusted_network"
            value = "some_trusted_network_address"
          }
        }

        dynamic "authorized_networks" {
          for_each = var.ip_configuration.authorized_networks != null ? var.ip_configuration.authorized_networks : []
          content {
            name  = "another_trusted_network"
            value = "another_trusted_network_address"
             }
          }
       }
     }
  }
}
