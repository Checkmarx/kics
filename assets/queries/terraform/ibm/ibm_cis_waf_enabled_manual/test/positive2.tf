resource "ibm_cis_domain_settings" "settings_missing" {
  cis_id    = "crn:v1:bluemix:public:internet-svcs:..."
  domain_id = "example-id"
  # FALLO: Falta el atributo waf
  ssl = "full"
}