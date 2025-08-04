resource "google_sql_database_instance" "positive1" {
  name             = "master-instance"
  database_version = "POSTGRES_11"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  }
}

resource "google_sql_database_instance" "positive2" {
  name             = "postgres-instance-2"
  database_version = "POSTGRES_11"

  settings {
    tier = "db-f1-micro"

    ip_configuration {

      authorized_networks {
        name  = "pub-network"
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "google_sql_database_instance" "positive3" {
  name             = "master-instance"
  database_version = "POSTGRES_11"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"

    ip_configuration {
        ipv4_enabled = true
    }
  }
}

resource "google_sql_database_instance" "positive4" {
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

resource "google_sql_database_instance" "positive2-dynamic" {
  provider             = google-beta

  settings {

    dynamic "ip_configuration" {
      for_each = var.ip_configuration == null ? [] : [true]
      content {
        
        dynamic "authorized_networks" {
          for_each = var.ip_configuration.authorized_networks != null ? var.ip_configuration.authorized_networks : []
          content {
            name  = "pub-network"
            value = "0.0.0.0/0"
          }
        }
       }
     }
  }
}


resource "google_sql_database_instance" "positive3-dynamic" {
  provider             = google-beta

  settings {
    tier = "db-f1-micro"
    dynamic "ip_configuration" {
      for_each = var.ip_configuration == null ? [] : [true]
      content {
        ipv4_enabled  = true
      }
    }
  }
}

resource "google_sql_database_instance" "positive4-dynamic" {
  provider             = google-beta

  settings {
    dynamic "ip_configuration" {}
  }
}

