resource "ibm_logdna_view" "error_view" {
  name  = "Critical-Errors-Only"
  query = "level:error"
}