#this code is a correct code for which the query should not find any result
resource "google_container_cluster" "primary" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret = var.my_google_secret

  secret_data = "secret-data"
}
