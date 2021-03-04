package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	instance.auth_kind == "serviceaccount"
	object.get(instance, "service_account_email", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.service_account_email is defined",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.service_account_email is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	instance.auth_kind == "serviceaccount"
	email := instance.service_account_email
	is_string(email)
	count(email) == 0

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.service_account_email", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.service_account_email is not empty",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.service_account_email is empty",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	instance.auth_kind == "serviceaccount"
	email := instance.service_account_email
	is_string(email)
	count(email) > 0
	not contains(email, "@")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.service_account_email", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.service_account_email is an email",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.service_account_email is not an email",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_compute_instance"]

	ansLib.checkState(instance)
	instance.auth_kind == "serviceaccount"
	email := instance.service_account_email
	contains(email, "@developer.gserviceaccount.com")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_instance}}.service_account_email", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_compute_instance}}.service_account_email is not a default Google Compute Engine service account",
		"keyActualValue": "{{google.cloud.gcp_compute_instance}}.service_account_email is a default Google Compute Engine service account",
	}
}
