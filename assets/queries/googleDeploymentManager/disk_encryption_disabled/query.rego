package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.instance"

	disks := resource.properties.disks[d]
	not common_lib.valid_key(disks, "diskEncryptionKey")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.disks", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'diskEncryptionKey' is defined and not null",
		"keyActualValue": "'diskEncryptionKey' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "disks", d], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.instance"

	disks := resource.properties.disks[d]
	not common_lib.valid_key(disks.diskEncryptionKey, "rawKey")
	not common_lib.valid_key(disks.diskEncryptionKey, "kmsKeyName")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.disks.diskEncryptionKey", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'disk_encryption_key.rawKey' or 'disk_encryption_key.kmsKeyName' is defined and not null",
		"keyActualValue": "'disk_encryption_key.rawKey' and 'disk_encryption_key.kmsKeyName' are undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "disks", d, "diskEncryptionKey"], []),
	}
}

fields := {"rawKey", "kmsKeyName"}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.instance"

	disks := resource.properties.disks[d]
	disks.diskEncryptionKey[fields[f]] == ""

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.disks.diskEncryptionKey.%s", [resource.name, fields[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'diskEncryptionKey.%s' is not empty", [fields[f]]),
		"keyActualValue": sprintf("'diskEncryptionKey.%s' is empty", [fields[f]]),
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "disks", d, "diskEncryptionKey", fields[f]], []),
	}
}
