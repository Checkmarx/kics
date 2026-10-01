# Negative case: No API Key resources exist, so there is no risk to audit.
resource "google_compute_network" "vpc" {
  name = "secure-network"
}