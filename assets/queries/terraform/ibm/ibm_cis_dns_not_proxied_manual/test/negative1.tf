resource "ibm_cis_dns_record" "dns_record_secure" {
  cis_id    = "crn:v1:bluemix:public:internet-svcs:..."
  domain_id = "example-id"
  name      = "www"
  type      = "A"
  content   = "1.2.3.4"
  
  # CORRECTO: Bajo el escudo de CIS
  proxied = true
}