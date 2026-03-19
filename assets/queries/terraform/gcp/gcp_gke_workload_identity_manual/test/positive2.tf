resource "google_container_cluster" "fail_manual_check" {
  name = "cluster-with-wi"
  
  workload_identity_config {
    workload_pool = "my-project.svc.id.goog"
  }
  # INFO: Requiere revisión manual de los bindings de las aplicaciones
}