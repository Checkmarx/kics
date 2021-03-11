package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcpTopic := task["google.cloud.gcp_kms_crypto_key"]

	ansLib.checkState(gcpTopic)
	object.get(gcpTopic, "rotation_period", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_kms_crypto_key}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_kms_key_ring}}.rotation_period is defined",
		"keyActualValue": "{{google.cloud.gcp_kms_key_ring}}.rotation_period is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcpTopic := task["google.cloud.gcp_kms_crypto_key"]

	ansLib.checkState(gcpTopic)
	rotationP := substring(gcpTopic.rotation_period, 0, count(gcpTopic.rotation_period) - 1)
	to_number(rotationP) < 7776000

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_kms_crypto_key}}.rotation_period", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_kms_key_ring}}.rotation_period is >= 7776000",
		"keyActualValue": "{{google.cloud.gcp_kms_key_ring}}.rotation_period is < 7776000",
	}
}
