package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	disk := task["google.cloud.gcp_compute_disk"]

	ansLib.checkState(disk)
	object.get(disk, "disk_encryption_key", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_disk}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google.cloud.gcp_compute_disk has a disk_encryption_key value",
		"keyActualValue": "google.cloud.gcp_compute_disk does not have a disk_encryption_key",
	}
}
