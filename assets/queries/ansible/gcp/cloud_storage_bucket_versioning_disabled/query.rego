package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"google.cloud.gcp_storage_bucket", "gcp_storage_bucket"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	storage_bucket := task[modules[m]]
	ansLib.checkState(storage_bucket)

	not common_lib.valid_key(storage_bucket, "versioning")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_storage_bucket.versioning should be defined",
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.versioning.enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_storage_bucket.versioning.enabled should be true",
		"keyActualValue": "gcp_storage_bucket.versioning.enabled is false",
	}
}
