#this is a problematic code where the query should report a result(s)
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  network_policy {
      enabled = true
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary2" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  network_policy {
      enabled = true
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary3" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary4" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  network_policy {
      enabled = true
  }
  addons_config {

  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary5" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  network_policy {
      enabled = false
  }
  addons_config {
    network_policy_config {
        disabled = false
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary6" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  network_policy {
      enabled = true
  }
  addons_config {
    network_policy_config {
        disabled = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}