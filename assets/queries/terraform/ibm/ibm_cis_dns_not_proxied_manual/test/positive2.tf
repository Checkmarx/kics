resource "ibm_cis_dns_record" "dns_record_missing" {
  cis_id    = "crn:v1:bluemix:public:internet-svcs:..."
  domain_id = "example-id"
  name      = "test-missing"
  type      = "A"
  content   = "192.168.1.2"
  # FALLO: Falta el atributo proxied
}