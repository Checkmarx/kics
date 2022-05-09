package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	sqs_queue := document[i].Resources[name]
	sqs_queue.Type == "AWS::SQS::Queue"

	info := cf_lib.get_resource_accessibility(name, "AWS::SQS::QueuePolicy", "Queues")

	bom_output = {
		"resource_type": "AWS::SQS::Queue",
		"resource_name": get_queue_name(sqs_queue),
		"resource_accessibility": info.accessibility,
		"resource_encryption": cf_lib.get_encryption(sqs_queue),
		"resource_vendor": "AWS",
		"resource_category": "Queues",
	}

	final_bom_output := common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["Resources", name], []),
		"value": json.marshal(final_bom_output),
	}
}

get_queue_name(sqs_queue) = name {
	name := sqs_queue.Properties.QueueName
} else = name {
	name := common_lib.get_tag_name_if_exists(sqs_queue)
} else = name {
	name := "unknown"
}
