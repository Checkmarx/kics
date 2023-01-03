package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	gc_disk := input.document[i].resource.google_compute_disk[name]

	bom_output = {
		"resource_type": "google_compute_disk",
		"resource_name": tf_lib.get_resource_name(gc_disk, name),
		"resource_accessibility": "unknown",
		"resource_encryption": check_encrytion(gc_disk),
		"resource_vendor": "GCP",
		"resource_category": "Storage",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_compute_disk[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "google_compute_disk", name], []),
		"value": json.marshal(bom_output),
	}
}

check_encrytion(resource) = enc_status {
	not common_lib.valid_key(resource, "disk_encryption_key")
	enc_status := "unencrypted"
} else = enc_status {
	not common_lib.valid_key(resource.disk_encryption_key, "raw_key")
	not common_lib.valid_key(resource.disk_encryption_key, "kms_key_self_link")
	enc_status := "unencrypted"
} else = enc_status {
	tf_lib.check_key_empty(resource.disk_encryption_key)
	enc_status := "unencrypted"
} else = enc_status {
	enc_status := "encrypted"
}
