
resource "google_sql_database_instance" "positive2_1" {
  name   = "private-instance-no-ssl-mode"
  database_version = "POSTGRES_15"
  region = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
      # Undefined "ssl_mode"
    }
  }
}

resource "google_sql_database_instance" "positive2_2" {
  name   = "private-instance-unspecified"
  database_version = "POSTGRES_15"
  region = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
      ssl_mode        = "SSL_MODE_UNSPECIFIED"  # Unexpected value
    }
  }
}

resource "google_sql_database_instance" "positive2_3" {
  name   = "private-instance-unencrypted"
  database_version = "POSTGRES_15"
  region = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
      ssl_mode        = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"  # Allows unencrypted (non-SSL/non-TLS) connections
    }
  }
}