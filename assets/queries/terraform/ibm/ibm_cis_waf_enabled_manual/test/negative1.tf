resource "ibm_cis_domain_settings" "settings_secure" {
  cis_id    = "crn:v1:bluemix:public:internet-svcs:..."
  domain_id = "example-id"
  
  # CORRECTO: WAF habilitado
  waf = "on"
}