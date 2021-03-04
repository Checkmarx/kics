package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storage_bucket := task["google.cloud.gcp_storage_bucket"]

	ansLib.checkState(storage_bucket)
	object.get(storage_bucket, "logging", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_storage_bucket}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_storage_bucket}}.logging is defined",
		"keyActualValue": "{{google.cloud.gcp_storage_bucket}}.logging is undefined",
	}
}
