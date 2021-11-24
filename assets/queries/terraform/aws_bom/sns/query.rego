package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	aws_sns_topic_resource := input.document[i].resource.aws_sns_topic[name]

	info := terra_lib.get_accessibility(aws_sns_topic_resource, name, "aws_sns_topic_policy", "arn")

	bom_output = {
		"resource_type": "aws_sns_topic",
		"resource_name": get_queue_name(aws_sns_topic_resource),
		"resource_accessibility": info.accessibility,
		"resource_vendor": "AWS",
		"resource_category": "Messaging",
		"policy": info.policy,
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sns_topic[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_sns_topic", name], []),
		"value": json.marshal(bom_output),
	}
}

get_queue_name(aws_sns_topic_resource) = name {
	name := aws_sns_topic_resource.name
} else {
	name := sprintf("%s<unknown-sufix>", [aws_sns_topic_resource.name_prefix])
} else {
	name := "unknown"
}
