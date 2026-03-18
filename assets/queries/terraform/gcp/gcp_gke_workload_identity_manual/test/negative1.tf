# Caso negativo: No hay clústeres GKE que auditar.
resource "google_compute_network" "vpc" {
  name = "main-vpc"
}