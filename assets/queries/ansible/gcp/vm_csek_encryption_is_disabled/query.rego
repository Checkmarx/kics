package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_compute_disk", "gcp_compute_disk"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	disk := task[modules[m]]
	ansLib.checkState(disk)

	object.get(disk, "disk_encryption_key", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_compute_disk.disk_encryption_key is defined",
		"keyActualValue": "gcp_compute_disk.disk_encryption_key is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	disk := task[modules[m]]
	ansLib.checkState(disk)

	object.get(disk.disk_encryption_key, "raw_key", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.disk_encryption_key", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_compute_disk.disk_encryption_key.raw_key is defined",
		"keyActualValue": "gcp_compute_disk.disk_encryption_key.raw_key is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	disk := task[modules[m]]
	ansLib.checkState(disk)

	ansLib.checkValue(disk.disk_encryption_key.raw_key)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.disk_encryption_key.raw_key", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_compute_disk.disk_encryption_key.raw_key is not empty or null",
		"keyActualValue": "gcp_compute_disk.disk_encryption_key.raw_key is empty or null",
	}
}
