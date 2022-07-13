package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"google.cloud.gcp_compute_disk", "gcp_compute_disk"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	disk := task[modules[m]]
	ansLib.checkState(disk)

	not common_lib.valid_key(disk, "disk_encryption_key")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_compute_disk.disk_encryption_key should be defined and not null",
		"keyActualValue": "gcp_compute_disk.disk_encryption_key is undefined or null",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	disk := task[modules[m]]
	ansLib.checkState(disk)

	not common_lib.valid_key(disk.disk_encryption_key, "raw_key")
	not common_lib.valid_key(disk.disk_encryption_key, "kms_key_name")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.disk_encryption_key", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_compute_disk.disk_encryption_key.raw_key or gcp_compute_disk.disk_encryption_key.kms_key_name should be defined and not null",
		"keyActualValue": "gcp_compute_disk.disk_encryption_key.raw_key and gcp_compute_disk.disk_encryption_key.kms_key_name are undefined or null",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	disk := task[modules[m]]
	ansLib.checkState(disk)

	key := check_key_empty(disk.disk_encryption_key)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.disk_encryption_key.%s", [task.name, modules[m], key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("gcp_compute_disk.disk_encryption_key.%s should not be empty", [key]),
		"keyActualValue": sprintf("gcp_compute_disk.disk_encryption_key.%s is empty", [key]),
	}
}

check_key_empty(disk_encryption_key) = key {
	common_lib.valid_key(disk_encryption_key, "raw_key")
	disk_encryption_key.raw_key == ""
	key := "raw_key"
} else = key {
	common_lib.valid_key(disk_encryption_key, "kms_key_name")
	disk_encryption_key.kms_key_name == ""
	key := "kms_key_name"
}
