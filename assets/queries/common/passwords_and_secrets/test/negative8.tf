resource "google_container_cluster" "primary5" {
  name               = "marcellus-wallace-credential"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = "PRIVATE KEY_key"
    password = ""

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}
