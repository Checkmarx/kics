resource "ibm_iam_user_policy" "insecure_policy" {
  ibm_id = "auditor@company.com"
  roles  = ["Viewer"]
  
  resources {
    resource_type = "resource-group"
  }
}