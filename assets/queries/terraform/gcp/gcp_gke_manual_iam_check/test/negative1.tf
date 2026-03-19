# En este caso negativo, no hay SA personalizada (se encargaría la regla de SA por defecto)
resource "google_container_cluster" "no_custom_sa" {
  name = "default-sa-cluster"
  # No define node_config.service_account
}