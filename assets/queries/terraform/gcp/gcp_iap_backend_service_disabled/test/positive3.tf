resource "google_compute_backend_service" "fail_no_secret" {
  name = "no-client-secret"
  iap {
    oauth2_client_id = "some-id"
  }
}