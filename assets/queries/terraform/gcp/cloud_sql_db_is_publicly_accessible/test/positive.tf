resource "google_sql_database_instance" "no_config" {
  name             = "master-instance"
  database_version = "POSTGRES_11"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  }
}

resource "google_sql_database_instance" "public_authorized_network" {
  name             = "postgres-instance-2"
  database_version = "POSTGRES_11"

  settings {
    tier = "db-f1-micro"

    ip_configuration {

      dynamic "authorized_networks" {

        content {
          name  = "pub-network"
          value = "0.0.0.0"
        }
      }
    }
  }
}

resource "google_sql_database_instance" "ipv4_enabled" {
  name             = "master-instance"
  database_version = "POSTGRES_11"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"

    ip_configuration {
        ipv4_enabled = true
        private_network = "some_private_network"
    }
  }
}

resource "google_sql_database_instance" "no_private_network_config" {
  name             = "master-instance"
  database_version = "POSTGRES_11"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"

    ip_configuration {}
  }
}