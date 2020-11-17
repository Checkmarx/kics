#this is a problematic code where the query should report a result(s)
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary2" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = "a"
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

  master_auth {
    password = "a"
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary4" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
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

  master_auth {
    username = ""
    password = "a"
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

  master_auth {
    username = "a"
    password = ""
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_container_cluster" "primary7" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = ""
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}