package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storage_bucket := task["google.cloud.gcp_storage_bucket"]

	ansLib.checkState(storage_bucket)
	object.get(storage_bucket, "versioning", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_storage_bucket}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning' is defined",
		"keyActualValue": "'versioning' is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storage_bucket := task["google.cloud.gcp_storage_bucket"]

	ansLib.checkState(storage_bucket)
	not ansLib.isAnsibleTrue(storage_bucket.versioning.enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_storage_bucket}}.versioning.enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'versioning.enabled' is true",
		"keyActualValue": "'versioning.enabled' is false",
	}
}
