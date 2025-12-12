resource "google_logging_metric" "audit_config_change_1" {    # checks that extra OR statement is allowed 1
  name        = "audit_config_change_1"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type="iam_role"
    AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
    protoPayload.methodName="google.iam.admin.v1.DeleteRole" OR
    protoPayload.methodName="google.iam.admin.v1.UpdateRole" OR
    protoPayload.methodName="google.iam.admin.v1.UndeleteRole" OR
    protoPayload.methodName="any_other_value")
  FILTER
}

resource "google_logging_metric" "audit_config_change_2" {      # checks that extra OR statement is allowed 2
  name        = "audit_config_change_2"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type="iam_role"
    AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
    protoPayload.methodName="google.iam.admin.v1.DeleteRole" OR
    protoPayload.methodName="google.iam.admin.v1.UpdateRole" OR
    protoPayload.methodName="google.iam.admin.v1.UndeleteRole") OR
    protoPayload.methodName="any_other_value"
  FILTER
}

resource "google_logging_metric" "audit_config_change_4" {       # checks that extra OR statement is allowed for resource.type 1
  name        = "audit_config_change_4"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type="iam_role" OR resource.type="any_other_resource_type"
    AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
    protoPayload.methodName="google.iam.admin.v1.UndeleteRole" OR
    protoPayload.methodName="google.iam.admin.v1.UpdateRole") OR
    protoPayload.methodName="google.iam.admin.v1.DeleteRole"
  FILTER
}

resource "google_logging_metric" "audit_config_change_5" {      # checks that extra OR statement is allowed for resource.type 2
  name        = "audit_config_change_5"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type= ("iam_role" OR "any_other_resource_type")
    AND protoPayload.methodName = ("google.iam.admin.v1.CreateRole" OR
                                   "google.iam.admin.v1.UndeleteRole" OR
                                   "google.iam.admin.v1.UpdateRole" OR
                                   "google.iam.admin.v1.DeleteRole")
  FILTER
}

resource "google_logging_metric" "audit_config_change_9" {       # checks that extra OR statement is allowed for resource.type 3
  name        = "audit_config_change_9"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type="any_other_resource_type" OR resource.type="iam_role"
    AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
    protoPayload.methodName="google.iam.admin.v1.UndeleteRole" OR
    protoPayload.methodName="google.iam.admin.v1.UpdateRole") OR
    protoPayload.methodName="google.iam.admin.v1.DeleteRole"
  FILTER
}

resource "google_logging_metric" "audit_config_change_10" {       # checks that extra OR statement is allowed for resource.type 4
  name        = "audit_config_change_10"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type= ("any_other_resource_type" OR "iam_role")
    AND protoPayload.methodName = ("google.iam.admin.v1.CreateRole" OR
                                   "google.iam.admin.v1.UndeleteRole" OR
                                   "google.iam.admin.v1.UpdateRole" OR
                                   "google.iam.admin.v1.DeleteRole")
  FILTER
}

resource "google_logging_metric" "audit_config_change_11" {            # checks that extra OR statement is allowed for resource.type 5
  name        = "audit_config_change_11"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type= ("type_1" OR "type_2" OR "type_3" OR  "type_4" OR "iam_role")
    AND protoPayload.methodName = ("google.iam.admin.v1.CreateRole" OR
                                   "google.iam.admin.v1.UndeleteRole" OR
                                   "google.iam.admin.v1.UpdateRole" OR
                                   "google.iam.admin.v1.DeleteRole")
  FILTER
}

resource "google_logging_metric" "audit_config_change_6" {      # checks many OR statements in a single line
  name        = "audit_config_change_6"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type= "iam_role"
    AND protoPayload.methodName = ("google.iam.admin.v1.CreateRole" OR "google.iam.admin.v1.UndeleteRole" OR "google.iam.admin.v1.UpdateRole" OR "google.iam.admin.v1.DeleteRole")
  FILTER
}

resource "google_logging_metric" "audit_config_change_7" {      # checks that unrestrictive protoPayload is also valid 1
  name        = "audit_config_change_7"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type= ("iam_role" OR "any_other_resource_type")
  FILTER
}

resource "google_logging_metric" "audit_config_change_8" {      # checks that unrestrictive protoPayload is also valid 2
  name        = "audit_config_change_8"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type = "iam_role"
    AND protoPayload.methodName = *
  FILTER
}

resource "google_logging_metric" "audit_config_change_4" {       # checks that extra OR statement is allowed for resource.type 1
  name        = "audit_config_change_4"
  description = "Detects changes to audit configurations via SetIamPolicy"
  filter = <<-FILTER
    resource.type="iam_role"
    AND (protoPayload.methodName = "google.iam.admin.v1.CreateRole" OR
    protoPayload.methodName = "google.iam.admin.v1.UndeleteRole" OR
    protoPayload.methodName = "google.iam.admin.v1.UpdateRole") OR
    protoPayload.any_other_field = "google.iam.admin.v1.DeleteRole"
  FILTER
}
