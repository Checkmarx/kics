package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_kms_crypto_key"]

	ansLib.checkState(instance)
	rotation_period := substring(instance.rotation_period, 0, count(instance.rotation_period) - 1)
	seconds_in_a_year := 315356000
	to_number(rotation_period) > seconds_in_a_year

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_kms_crypto_key}}.rotation_period", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_kms_crypto_key}}.rotation_period is at most '315356000s'", [task.name]),
		"keyActualValue": sprintf("name=%s.{{google.cloud.gcp_kms_crypto_key}}.rotation_period is '%ss'", [task.name, rotation_period]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["google.cloud.gcp_kms_crypto_key"]

	ansLib.checkState(instance)
	object.get(instance, "rotation_period", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_kms_crypto_key}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_kms_crypto_key}}.rotation_period is set", [task.name]),
		"keyActualValue": sprintf("name=%s.{{google.cloud.gcp_kms_crypto_key}}.rotation_period is undefined", [task.name]),
	}
}
