package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_disk[name]
	not common_lib.valid_key(resource, "disk_encryption_key")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_disk",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_disk[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_disk[%s].disk_encryption_key' should be defined and not null", [name]),
		"keyActualValue": sprintf("'google_compute_disk[%s].disk_encryption_key' is undefined or null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_disk[name]

	not common_lib.valid_key(resource.disk_encryption_key, "raw_key")
	not common_lib.valid_key(resource.disk_encryption_key, "kms_key_self_link")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_disk",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_disk[%s].disk_encryption_key", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'google_compute_disk[%s].disk_encryption_key.raw_key' or 'google_compute_disk[%s].disk_encryption_key.kms_key_self_link' should be defined and not null", [name]),
		"keyActualValue": sprintf("'google_compute_disk[%s].disk_encryption_key.raw_key' and 'google_compute_disk[%s].disk_encryption_key.kms_key_self_link' are undefined or null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_compute_disk[name]
	key := tf_lib.check_key_empty(resource.disk_encryption_key)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_compute_disk",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_compute_disk[%s].disk_encryption_key.%s", [name, key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'google_compute_disk[%s].disk_encryption_key.%s' should not be empty or null", [name, key]),
		"keyActualValue": sprintf("'google_compute_disk[%s].disk_encryption_key.%s' is not empty or null", [name, key]),
	}
}


