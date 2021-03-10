resource "google_compute_ssl_policy" "positive1" {
  name            = "custom-ssl-policy"
  min_tls_version = "TLS_1_1"
  profile         = "CUSTOM"
  custom_features = ["TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384", "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"]
}

resource "google_compute_ssl_policy" "positive2" {
  name            = "custom-ssl-policy"
  profile         = "CUSTOM"
  custom_features = ["TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384", "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"]
}