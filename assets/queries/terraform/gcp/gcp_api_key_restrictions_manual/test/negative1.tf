# Caso negativo: No existen recursos de API Key, por lo que no hay riesgo que auditar.
resource "google_compute_network" "vpc" {
  name = "secure-network"
}