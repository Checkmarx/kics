resource "google_container_cluster" "primary1" {
  name = "marcellus-wallace"
  location = "us-central1-a"
  initial_node_count = 3

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary2" {
  name = "marcellus-wallace"
  location = "us-central1-a"
  initial_node_count = 3
  private_cluster_config {
        enable_private_endpoint = true
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary3" {
  name = "marcellus-wallace"
  location = "us-central1-a"
  initial_node_count = 3
  private_cluster_config {
        enable_private_nodes = true
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary4" {
  name = "marcellus-wallace"
  location = "us-central1-a"
  initial_node_count = 3
  private_cluster_config {

  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary5" {
  name = "marcellus-wallace"
  location = "us-central1-a"
  initial_node_count = 3
  private_cluster_config {
        enable_private_endpoint = false
        enable_private_nodes = true
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary6" {
  name = "marcellus-wallace"
  location = "us-central1-a"
  initial_node_count = 3
  private_cluster_config {
        enable_private_endpoint = true
        enable_private_nodes = false
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary7" {
  name = "marcellus-wallace"
  location = "us-central1-a"
  initial_node_count = 3
  private_cluster_config {
        enable_private_endpoint = false
        enable_private_nodes = false
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}
