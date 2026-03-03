resource "google_logging_metric" "audit_config_change_1" {     # test cor case insensitivety
  name        = "audit_config_change_1"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    ReSOuRcE.tYpE="iam_role"
    AND (ProTOPAyLoAD.METHODName = "google.iam.admin.v1.CreateRole" OR
    PRotoPayLOAD.methodNAME="google.iam.admin.v1.DeleteRole" OR
    PROTOPAYLOAD.MEthoDNAme="google.iam.admin.v1.UpdateRole" OR
    ProTOPAyLoAD.METhodNAME="google.iam.admin.v1.UndeleteRole" OR
    PRotoPayLOAD.MeTHoDNAME="any_other_value")
  FILTER
}
