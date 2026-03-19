resource "ibm_cis_dns_record" "dns_record_false" {
  cis_id    = "crn:v1:bluemix:public:internet-svcs:..."
  domain_id = "example-id"
  name      = "test"
  type      = "A"
  content   = "192.168.1.1"
  
  # FALLO: Deshabilitado explícitamente
  proxied = false
}