package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	aws_sns_queue_resource := input.document[i].resource.aws_sns_queue[name]

	bom_output = {
		"resource_type": "aws_sns_queue",
		"resource_name": aws_sns_queue_resource.name,
		# TODO: need to check SNS policy
		"resource_accessibility": "unknown",
		"resource_vendor": "AWS",
		"resource_category": "Queues",
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sns_queue[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_sns_queue", name], []),
		"value": json.marshal(bom_output),
	}
}
