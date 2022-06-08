package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	aws_sns_topic_resource := input.document[i].resource.aws_sns_topic[name]

	info := tf_lib.get_accessibility(aws_sns_topic_resource, name, "aws_sns_topic_policy", "arn")

	bom_output = {
		"resource_type": "aws_sns_topic",
		"resource_name": tf_lib.get_resource_name(aws_sns_topic_resource, name),
		"resource_accessibility": info.accessibility,
		"resource_encryption": common_lib.get_encryption_if_exists(aws_sns_topic_resource),
		"resource_vendor": "AWS",
		"resource_category": "Messaging",
	}

	final_bom_output := common_lib.get_bom_output(bom_output, info.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sns_topic[%s]", [name]),
		"issueType": "BillOfMaterials",
		"keyExpectedValue": "",
		"keyActualValue": "",
		"searchLine": common_lib.build_search_line(["resource", "aws_sns_topic", name], []),
		"value": json.marshal(final_bom_output),
	}
}
