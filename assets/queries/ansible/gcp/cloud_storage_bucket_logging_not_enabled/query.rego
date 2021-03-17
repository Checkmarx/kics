package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_storage_bucket", "gcp_storage_bucket"}
	storage_bucket := task[modules[m]]
	ansLib.checkState(storage_bucket)

	object.get(storage_bucket, "logging", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_storage_bucket.logging is defined",
		"keyActualValue": "gcp_storage_bucket.logging is undefined",
	}
}
