package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_kms_crypto_key", "gcp_kms_crypto_key"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcpTopic := task[modules[m]]
	ansLib.checkState(gcpTopic)

	object.get(gcpTopic, "rotation_period", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_kms_key_ring.rotation_period is defined",
		"keyActualValue": "gcp_kms_key_ring.rotation_period is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcpTopic := task[modules[m]]
	ansLib.checkState(gcpTopic)

	rotationP := substring(gcpTopic.rotation_period, 0, count(gcpTopic.rotation_period) - 1)
	to_number(rotationP) < 7776000

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rotation_period", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_kms_key_ring.rotation_period is >= 7776000",
		"keyActualValue": "gcp_kms_key_ring.rotation_period is < 7776000",
	}
}
