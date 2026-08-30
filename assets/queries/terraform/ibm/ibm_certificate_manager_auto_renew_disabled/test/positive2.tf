resource "ibm_cm_certificate" "cert_disabled" {
  instance_id = "crn:v1:bluemix:public:cloudcerts:..."
  name        = "cert-disabled"
  label       = "test"
  
  # FAIL: Deshabilitado explícitamente
  auto_renew_enabled = false
}