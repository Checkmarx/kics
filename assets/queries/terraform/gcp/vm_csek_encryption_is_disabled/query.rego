package Cx

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
	resource.disk_encryption_key
	object.get(resource.disk_encryption_key, "sha256", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_disk[%s].disk_encryption_key", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_disk[%s].disk_encryption_key.sha256' is defined", [name]),
		"keyActualValue": sprintf("'google_compute_disk[%s].disk_encryption_key' is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_disk[name]
	count(resource.disk_encryption_key.sha256) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_disk[%s].disk_encryption_key.sha256", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'disk_encryption_key.sha256' is not empty",
		"keyActualValue": "Attribute 'disk_encryption_key.sha256' is empty",
	}
}
