package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	pubsub_topic := input.document[i].resources[idx]
	pubsub_topic.type == "pubsub.v1.topic"

	bom_output = {
		"resource_type": pubsub_topic.type,
		"resource_name": pubsub_topic.name,
		"resource_accessibility": "unknown",
		"resource_encryption": check_encrytion(pubsub_topic.properties),
		"resource_vendor": "GCP",
		"resource_category": "Messaging",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}", [pubsub_topic.name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", idx], []),
		"value": json.marshal(bom_output),
	}
}

check_encrytion(properties) = enc_status {
	not common_lib.valid_key(properties, "kmsKeyName")
	enc_status := "encrypted"
} else = enc_status {
	enc_status := "unencrypted"
}

