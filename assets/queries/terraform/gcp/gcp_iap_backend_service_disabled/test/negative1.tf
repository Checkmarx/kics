resource "google_compute_backend_service" "pass_secure" {
  name = "fully-secure-service"
  
  iap {
    oauth2_client_id     = "client-id"
    oauth2_client_secret = "secret-val"
  }
}