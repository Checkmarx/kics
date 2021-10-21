package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	aws_sqs_queue_resource := input.document[i].resource.aws_sqs_queue[name]

	bom_output = {
		"resource_type": "aws_sqs_queue",
		"resource_name": get_queue_name(aws_sqs_queue_resource),
		# TODO: need to check SQS policy
		"resource_accessibility": "unknown",
		"resource_vendor": "AWS",
		"resource_category": "Queues",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue", name], []),
		"value": json.marshal(bom_output),
	}
}

get_queue_name(aws_sqs_queue_resource) = name {
	name := aws_sqs_queue_resource.name
} else {
	name := sprintf("%s<unknown-sufix>", [aws_sqs_queue_resource.name_prefix])
} else {
	name := "unknown"
}
