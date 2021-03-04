package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	disk := task["google.cloud.gcp_compute_disk"]

	ansLib.checkState(disk)
	object.get(disk, "disk_encryption_key", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_disk}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_compute_disk}}.disk_encryption_key is defined",
		"keyActualValue": "{{google.cloud.gcp_compute_disk}}.disk_encryption_key is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	disk := task["google.cloud.gcp_compute_disk"]

	ansLib.checkState(disk)
	object.get(disk.disk_encryption_key, "raw_key", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_disk}}.disk_encryption_key", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "{{google.cloud.gcp_compute_disk}}.disk_encryption_key.raw_key is defined",
		"keyActualValue": "{{google.cloud.gcp_compute_disk}}.disk_encryption_key.raw_key is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	disk := task["google.cloud.gcp_compute_disk"]

	ansLib.checkState(disk)
	ansLib.checkValue(disk.disk_encryption_key.raw_key)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{google.cloud.gcp_compute_disk}}.disk_encryption_key.raw_key", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_compute_disk}}.disk_encryption_key.raw_key is not empty or null",
		"keyActualValue": "{{google.cloud.gcp_compute_disk}}.disk_encryption_key.raw_key is empty or null",
	}
}
