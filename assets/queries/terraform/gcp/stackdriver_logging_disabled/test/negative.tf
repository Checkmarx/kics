#this code is a correct code for which the query should not find any result
resource "google_container_cluster" "negative1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  logging_service = "logging.googleapis.com/kubernetes"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

# Logging service defaults to Stackdriver, so it's okay to be undefined
resource "google_container_cluster" "negative2" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  
  timeouts {
    create = "30m"
    update = "40m"
  }
}