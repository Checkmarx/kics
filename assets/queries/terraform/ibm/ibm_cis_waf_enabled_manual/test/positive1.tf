resource "ibm_cis_domain_settings" "settings_off" {
  cis_id    = "crn:v1:bluemix:public:internet-svcs:..."
  domain_id = "example-id"
  
  # FALLO: WAF desactivado
  waf = "off"
}