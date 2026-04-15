resource "ibm_cm_certificate" "cert_compliant" {
  instance_id = "crn:v1:bluemix:public:cloudcerts:..."
  name        = "cert-compliant"
  label       = "secure"
  
  # PASS
  auto_renew_enabled = true
}