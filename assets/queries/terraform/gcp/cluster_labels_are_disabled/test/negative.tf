#this code is a correct code for which the query should not find any result
resource "google_container_cluster" "negative1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  resource_labels {
      
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}
