resource "ibm_cm_certificate" "cert_missing_attr" {
  instance_id = "crn:v1:bluemix:public:cloudcerts:..."
  name        = "cert-missing"
  label       = "test"
  # FALLO: Falta auto_renew_enabled
}