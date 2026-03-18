# Las claves de Service ID son el estándar seguro y no disparan esta alerta
resource "ibm_iam_service_id" "service_id" {
  name = "safe-service"
}

resource "ibm_iam_service_api_key" "service_key" {
  name           = "safe-key"
  iam_service_id = ibm_iam_service_id.service_id.iam_id
}