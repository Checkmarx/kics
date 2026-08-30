resource "google_compute_backend_service" "fail_no_id" {
  name = "no-client-id"
  iap {
    oauth2_client_secret = "some-secret"
  }
}