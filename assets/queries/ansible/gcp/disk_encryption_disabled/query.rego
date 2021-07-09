package Cx

import data.generic.ansible as ansLib
import data.generic.common as commonLib

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
	object.get(disk.disk_encryption_key, "kms_key_name", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.disk_encryption_key", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_compute_disk.disk_encryption_key.raw_key or gcp_compute_disk.disk_encryption_key.kms_key_name is defined",
		"keyActualValue": "gcp_compute_disk.disk_encryption_key.raw_key and gcp_compute_disk.disk_encryption_key.kms_key_name are undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	disk := task[modules[m]]
	ansLib.checkState(disk)

	key := check_key_empty(disk.disk_encryption_key)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.disk_encryption_key.%s", [task.name, modules[m], key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("gcp_compute_disk.disk_encryption_key.%s is not empty or null", [key]),
		"keyActualValue": sprintf("gcp_compute_disk.disk_encryption_key.%s is empty or null", [key]),
	}
}

check_key_empty(disk_encryption_key) = key {
	object.get(disk_encryption_key, "raw_key", "undefined") != "undefined"
	commonLib.emptyOrNull(disk_encryption_key.raw_key)
	key := "raw_key"
} else = key {
	object.get(disk_encryption_key, "kms_key_name", "undefined") != "undefined"
	commonLib.emptyOrNull(disk_encryption_key.kms_key_name)
	key := "kms_key_name"
}
