package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_project_iam_audit_config[name]

	resource.service != "allServices"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project_iam_audit_config",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_project_iam_audit_config[%s].service", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'service' must be 'allServices'",
		"keyActualValue": sprintf("'service' is '%s'", [resource.service]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_project_iam_audit_config[name]

	count(resource.audit_log_config) < 3

	audit_log_config = resource.audit_log_config[j]
	audit_log_config.log_type != "DATA_READ"
	audit_log_config.log_type != "DATA_WRITE"
	audit_log_config.log_type != "ADMIN_READ"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project_iam_audit_config",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_project_iam_audit_config[%s].audit_log_config.log_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'log_type' must be one of 'DATA_READ', 'DATA_WRITE', or 'ADMIN_READ'",
		"keyActualValue": sprintf("'log_type' is %s", [audit_log_config.log_type]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_project_iam_audit_config[name]
	audit_log_config = resource.audit_log_config[_]

	exempted_members = audit_log_config.exempted_members
	count(exempted_members) != 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_project_iam_audit_config",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_project_iam_audit_config[%s].audit_log_config.exempted_members", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'exempted_members' should be empty",
		"keyActualValue": "'exempted_members' is not empty",
	}
}
