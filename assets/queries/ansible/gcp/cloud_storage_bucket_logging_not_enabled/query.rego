package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_storage_bucket", "gcp_storage_bucket"}
	storage_bucket := task[modules[m]]
	ansLib.checkState(storage_bucket)

	not common_lib.valid_key(storage_bucket, "logging")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_storage_bucket.logging should be defined",
		"keyActualValue": "gcp_storage_bucket.logging is undefined",
	}
}
