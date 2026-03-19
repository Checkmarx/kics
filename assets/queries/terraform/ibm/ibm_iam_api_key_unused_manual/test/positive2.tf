resource "ibm_iam_service_api_key" "app_key" {
  name           = "automation-key"
  service_id_crn = "crn:v1:bluemix:public:iam-identity::a/123::serviceid:ServiceId-123"
}