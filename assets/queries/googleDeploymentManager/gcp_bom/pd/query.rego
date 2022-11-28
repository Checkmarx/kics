package Cx

import data.generic.common as common_lib

valid_disk_resources := {"compute.beta.disk","compute.v1.disk"}

CxPolicy[result] {
	gc_disk := input.document[i].resources[idx]
	gc_disk.type == valid_disk_resources[_]

	bom_output = {
		"resource_type": gc_disk.type,
		"resource_name": gc_disk.name,
		"resource_accessibility": "unknown",
		"resource_encryption": check_encrytion(gc_disk),
		"resource_vendor": "GCP",
		"resource_category": "Storage",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}", [gc_disk.name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", idx], []),
		"value": json.marshal(bom_output),
	}
}

check_encrytion(properties) = enc_status {
	not common_lib.valid_key(properties, "diskEncryptionKey")
	enc_status := "unencrypted"
} else = enc_status {
	not common_lib.valid_key(properties.diskEncryptionKey, "rawKey")
	not common_lib.valid_key(properties.diskEncryptionKey, "kmsKeyName")
	enc_status := "unencrypted"
} else = enc_status {
	check_key_empty(properties.diskEncryptionKey)
	enc_status := "unencrypted"
} else = enc_status {
	enc_status := "encrypted"
}

check_key_empty(diskEncryptionKey){
	common_lib.valid_key(diskEncryptionKey, "rawKey")
	common_lib.emptyOrNull(diskEncryptionKey.rawKey)
} else {
	common_lib.valid_key(diskEncryptionKey, "kmsKeyName")
	common_lib.emptyOrNull(diskEncryptionKey.kmsKeyName)
}
