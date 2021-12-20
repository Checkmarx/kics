package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	aws_sqs_queue_resource := input.document[i].resource.aws_sqs_queue[name]

	info := terra_lib.get_accessibility(aws_sqs_queue_resource, name, "aws_sqs_queue_policy", "queue_url")

	bom_output = {
		"resource_type": "aws_sqs_queue",
		"resource_name": get_queue_name(aws_sqs_queue_resource),
		"resource_accessibility": info.accessibility,
		"resource_vendor": "AWS",
		"resource_category": "Queues",
		"policy": info.policy,
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

CxPolicy[result] {
	aws_sqs_queue_policy_resource := input.document[i].resource.aws_sqs_queue_policy[name]

	policy := common_lib.json_unmarshal(aws_sqs_queue_policy_resource.policy)
	info := get_accessibility(policy)

	bom_output = {
		"resource_type": "aws_sqs_queue_policy",
		"resource_name": split(aws_sqs_queue_policy_resource.queue_url, ".")[1],
		"resource_accessibility": info.accessibility,
		"resource_vendor": "AWS",
		"resource_category": "Queues",
		"policy": info.policy,
	}

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue_policy[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue_policy", name], []),
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


get_accessibility(policy) = info {
	terra_lib.is_publicly_accessible(policy)
	info = {"accessibility": "public", "policy": policy}
} else = info {
	not  terra_lib.is_publicly_accessible(policy)
	info = {"accessibility": "restrict", "policy": policy}
}
