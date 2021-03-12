package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_storage_bucket", "gcp_storage_bucket"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storage_bucket := task[modules[m]]
	ansLib.checkState(storage_bucket)

	object.get(storage_bucket, "versioning", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_storage_bucket.versioning is defined",
		"keyActualValue": "gcp_storage_bucket.versioning is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storage_bucket := task[modules[m]]
	ansLib.checkState(storage_bucket)

	not ansLib.isAnsibleTrue(storage_bucket.versioning.enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.versioning.enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_storage_bucket.versioning.enabled is true",
		"keyActualValue": "gcp_storage_bucket.versioning.enabled is false",
	}
}
