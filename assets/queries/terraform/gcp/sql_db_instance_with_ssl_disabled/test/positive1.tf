resource "google_sql_database_instance" "positive1" {   # legacy support (terraform version < 6.0.1)
  provider = google-beta

  name   = "private-instance-${random_id.db_name_suffix.hex}"
  region = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"  # Missing "ip_configuration"
  }
}

resource "google_sql_database_instance" "positive2" {   # legacy support (terraform version < 6.0.1)
  provider = google-beta

  name   = "private-instance-${random_id.db_name_suffix.hex}"
  region = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
      # Missing "require_ssl"
    }
  }
}

resource "google_sql_database_instance" "positive3" {   # legacy support (terraform version < 6.0.1)
  provider = google-beta

  name   = "private-instance-${random_id.db_name_suffix.hex}"
  region = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
	    require_ssl 	  = false
    }
  }
}