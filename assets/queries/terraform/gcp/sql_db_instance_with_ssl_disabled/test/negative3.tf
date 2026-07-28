resource "google_sql_database_instance" "negative3_1" {
  name   = "private-instance-encrypted"
  database_version = "SQLSERVER_2017_STANDARD"
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