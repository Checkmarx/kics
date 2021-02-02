package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_disk[name]
	object.get(resource, "disk_encryption_key", "not found") == "not found"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_disk[%s].disk_encryption_key", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'disk_encryption_key' is not equal 'null'",
		"keyActualValue": "'disk_encryption_key' is equal 'null'",
	}
}
