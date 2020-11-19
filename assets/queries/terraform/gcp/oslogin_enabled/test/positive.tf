#this is a problematic code where the query should report a result(s)
resource "google_compute_project_metadata" "login_false_1" {
  metadata = {
    enable-oslogin = false
  }
}

resource "google_compute_project_metadata" "login_false_2" {
  metadata = {
      foo  = "bar"
  }
}