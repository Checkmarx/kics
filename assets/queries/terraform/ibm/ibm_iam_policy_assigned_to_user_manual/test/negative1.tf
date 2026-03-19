# Uso correcto de políticas mediante grupos de acceso
resource "ibm_iam_access_group" "auditors" {
  name = "Audit-Team"
}

resource "ibm_iam_access_group_policy" "group_policy" {
  access_group_id = ibm_iam_access_group.auditors.id
  roles           = ["Viewer"]
}

resource "ibm_iam_access_group_members" "members" {
  access_group_id = ibm_iam_access_group.auditors.id
  ibm_ids         = ["auditor@company.com"]
}