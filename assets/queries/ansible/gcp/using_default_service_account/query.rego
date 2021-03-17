package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_compute_instance", "gcp_compute_instance"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	instance.auth_kind == "serviceaccount"
	object.get(instance, "service_account_email", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_compute_instance.service_account_email is defined",
		"keyActualValue": "gcp_compute_instance.service_account_email is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	instance.auth_kind == "serviceaccount"
	email := instance.service_account_email
	is_string(email)
	count(email) == 0

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.service_account_email", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_compute_instance.service_account_email is not empty",
		"keyActualValue": "gcp_compute_instance.service_account_email is empty",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	instance.auth_kind == "serviceaccount"
	email := instance.service_account_email
	is_string(email)
	count(email) > 0
	not contains(email, "@")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.service_account_email", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_compute_instance.service_account_email is an email",
		"keyActualValue": "gcp_compute_instance.service_account_email is not an email",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	instance.auth_kind == "serviceaccount"
	email := instance.service_account_email
	contains(email, "@developer.gserviceaccount.com")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.service_account_email", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_compute_instance.service_account_email is not a default Google Compute Engine service account",
		"keyActualValue": "gcp_compute_instance.service_account_email is a default Google Compute Engine service account",
	}
}
