#this is a problematic code where the query should report a result(s)
data "google_compute_instance" "appserver" {
  name = "primary-application-server"
  zone = "us-central1-a"
  can_ip_forward = true
}