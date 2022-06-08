package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	aws_sqs_queue_resource := input.document[i].resource.aws_sqs_queue[name]

	info := tf_lib.get_accessibility(aws_sqs_queue_resource, name, "aws_sqs_queue_policy", "queue_url")

	bom_output = {
		"resource_type": "aws_sqs_queue",
		"resource_name": tf_lib.get_resource_name(aws_sqs_queue_resource, name),
		"resource_accessibility": info.accessibility,
		"resource_encryption": common_lib.get_encryption_if_exists(aws_sqs_queue_resource),
		"resource_vendor": "AWS",
		"resource_category": "Queues",
	}

	final_bom_output := common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue", name], []),
		"value": json.marshal(final_bom_output),
	}
}
