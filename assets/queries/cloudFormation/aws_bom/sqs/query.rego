package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document
	sqs_queue := document[i].Resources[name]
	sqs_queue.Type == "AWS::SQS::Queue"

	bom_output = {
		"resource_type": "AWS::SQS::Queue",
		"resource_name": get_queue_name(sqs_queue),
		"resource_accessibility": "TO DO",
		"resource_encryption": get_encryption(sqs_queue),
		"resource_vendor": "AWS",
		"resource_category": "Queues",
		"policy": "TO DO",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
		"value": json.marshal(bom_output),
	}
}

get_queue_name(sqs_queue) = name {
	name := sqs_queue.Properties.QueueName
} else = name {
	name := "unknown"
}

get_encryption(sqs_queue) = encryption {
	common_lib.valid_key(sqs_queue.Properties, "KmsMasterKeyId")
	encryption := "encrypted"
} else = encryption {
	encryption := "unencrypted"
}

