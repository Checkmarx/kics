package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"google.cloud.gcp_kms_crypto_key", "gcp_kms_crypto_key"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcpTopic := task[modules[m]]
	ansLib.checkState(gcpTopic)

	not common_lib.valid_key(gcpTopic, "rotation_period")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_kms_crypto_key.rotation_period should be defined with a value less or equal to 7776000",
		"keyActualValue": "gcp_kms_crypto_key.rotation_period is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	gcpTopic := task[modules[m]]
	ansLib.checkState(gcpTopic)

	rotationPeriod := substring(gcpTopic.rotation_period, 0, count(gcpTopic.rotation_period) - 1)
	to_number(rotationPeriod) > 7776000

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.rotation_period", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_kms_crypto_key.rotation_period should be less or equal to 7776000",
		"keyActualValue": "gcp_kms_crypto_key.rotation_period exceeds 7776000",
	}
}
