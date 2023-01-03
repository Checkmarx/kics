package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	dataflow_job := input.document[i].resource.google_dataflow_job[name]

	bom_output = {
		"resource_type": "google_dataflow_job",
		"resource_name": tf_lib.get_resource_name(dataflow_job, name),
		"resource_accessibility": check_accessability(dataflow_job),
		"resource_encryption": check_encrytion(dataflow_job),
		"resource_vendor": "GCP",
		"resource_category": "Streaming",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_dataflow_job[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "google_dataflow_job", name], []),
		"value": json.marshal(bom_output),
	}
}

check_encrytion(resource) = enc_status {
	common_lib.valid_key(resource, "kms_key_name")
	enc_status := "encrypted"
} else = enc_status {
	enc_status := "unencrypted"
}

check_accessability(resource) = acc_status {
	resource.ip_configuration == "WORKER_IP_PUBLIC"
	acc_status := "public"
} else = acc_status {
	acc_status := "unknown"
}
