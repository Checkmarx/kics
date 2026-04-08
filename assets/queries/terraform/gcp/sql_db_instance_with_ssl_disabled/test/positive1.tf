resource "google_sql_database_instance" "positive1_1" {   # legacy support (terraform version < 6.0.1)
  provider = google-beta

  name   = "private-instance-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_15"
  region = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"  # Undefined "ip_configuration"
  }
}

resource "google_sql_database_instance" "positive1_2" {   # legacy support (terraform version < 6.0.1)
  provider = google-beta

  name   = "private-instance-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_15"
  region = "us-central1"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id
      # Undefined "require_ssl"
    }
  }
}

resource "google_sql_database_instance" "positive1_3" {   # legacy support (terraform version < 6.0.1)
  provider = google-beta

  name   = "private-instance-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_15"
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