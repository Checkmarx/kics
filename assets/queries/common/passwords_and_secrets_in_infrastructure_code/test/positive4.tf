#this is a problematic code where the query should report a result(s)
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = "root"

    client_certificate_config {
      issue_client_certificate = true
    }
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

  master_auth {
    username = ""
    password = "pwd_jsuwauJk212"

    client_certificate_config {
      issue_client_certificate = true
    }
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
    username = "1234567890qwertyuiopasdfghjklçzxcvbnm"
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

resource "google_container_cluster" "primary4" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = "abcd    s"

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

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

resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret-version"

  labels = {
    label = "my-label"
  }

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret = "sasdsadwda"

  secret_data = "secret-data"
}
