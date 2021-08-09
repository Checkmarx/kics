package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_disk[name]
	object.get(resource, "disk_encryption_key", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_disk[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_disk[%s].disk_encryption_key' is defined", [name]),
		"keyActualValue": sprintf("'google_compute_disk[%s].disk_encryption_key' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_disk[name]

	object.get(resource.disk_encryption_key, "raw_key", "undefined") == "undefined"
	object.get(resource.disk_encryption_key, "kms_key_self_link", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_disk[%s].disk_encryption_key", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_disk[%s].disk_encryption_key.raw_key' or 'google_compute_disk[%s].disk_encryption_key.kms_key_self_link' is defined", [name]),
		"keyActualValue": sprintf("'google_compute_disk[%s].disk_encryption_key.raw_key' and 'google_compute_disk[%s].disk_encryption_key.kms_key_self_link' are undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_disk[name]
	key := check_key_empty(resource.disk_encryption_key)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_disk[%s].disk_encryption_key.%s", [name, key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_disk[%s].disk_encryption_key.%s' is not empty or null", [name, key]),
		"keyActualValue": sprintf("'google_compute_disk[%s].disk_encryption_key.%s' is not empty or null", [name, key]),
	}
}

check_key_empty(disk_encryption_key) = key {
	object.get(disk_encryption_key, "raw_key", "undefined") != "undefined"
	commonLib.emptyOrNull(disk_encryption_key.raw_key)
	key := "raw_key"
} else = key {
	object.get(disk_encryption_key, "kms_key_self_link", "undefined") != "undefined"
	commonLib.emptyOrNull(disk_encryption_key.kms_key_self_link)
	key := "kms_key_self_link"
}
