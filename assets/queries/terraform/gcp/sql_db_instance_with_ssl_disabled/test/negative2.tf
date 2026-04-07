resource "google_sql_database_instance" "negative1" {
  name   = "private-instance-encrypted"
  region = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
      ssl_mode        = "ENCRYPTED_ONLY"  # Only allows connections encrypted with SSL/TLS
    }
  }
}

resource "google_sql_database_instance" "negative2" {
  name   = "private-instance-trusted-cert"
  region = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
      ssl_mode        = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"  # Only allow connections encrypted with SSL/TLS and with valid client certificates
    }
  }
}