resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = "varexample"

    client_certificate_config {
      issue_client_certificate = true
      password = var.example
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}
