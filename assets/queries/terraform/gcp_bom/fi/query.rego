package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	g_fsi := input.document[i].resource.google_filestore_instance[name]

	bom_output = {
		"resource_type": "google_filestore_instance",
		"resource_name": tf_lib.get_resource_name(g_fsi, name),
		"resource_accessibility": check_accessability(g_fsi),
		"resource_encryption": check_encrytion(g_fsi),
		"resource_vendor": "GCP",
		"resource_category": "Storage",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_filestore_instance[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "google_filestore_instance", name], []),
		"value": json.marshal(bom_output),
	}
}

check_encrytion(resource) = enc_status {
	not common_lib.valid_key(resource, "kms_key_name")
	enc_status := "encrypted"
} else = enc_status {
	enc_status := "unencrypted"
}

check_accessability(resource) = acc_status {
	ip_ranges := resource.file_shares.nfs_export_options
	common_lib.is_unrestricted(ip_ranges[_])
	acc_status := "public"
} else = acc_status {
	ip_ranges := resource.file_shares.nfs_export_options[_]
	common_lib.is_unrestricted(ip_ranges[_])
	acc_status := "public"
} else = acc_status {
	acc_status := "unknown"
}
