resource "ibm_iam_access_group_policy" "broad_group_policy" {
  access_group_id = "access-group-id"
  roles           = ["Editor", "Viewer"] # Alerta: Editor permite creación de credenciales
  
  resources {
    service = "iam-identity"
  }
}