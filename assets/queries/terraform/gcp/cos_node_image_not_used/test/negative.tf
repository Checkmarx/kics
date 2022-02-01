resource "google_container_cluster" "negative1" {
  name     = "my-gke-cluster"
  location = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 1
}


resource "google_container_node_pool" "negative2" {
  project = "gcp_project"
  name    = "primary-pool"
  region  = "us-west1"
  cluster = google_container_cluster.primary.name

  node_config {
    image_type   = "COS"
  }
}

 resource "google_container_node_pool" "negative3" {
  project = "gcp_project"
  name    = "primary-pool2"
  region  = "us-west1"
  cluster = google_container_cluster.primary.name
 }

resource "google_container_node_pool" "negative4" {
  project = "gcp_project"
  name    = "primary-pool2"
  region  = "us-west1"
  cluster = google_container_cluster.primary.name

  node_config {
    image_type   = "COS_CONTAINERD"
  }
}