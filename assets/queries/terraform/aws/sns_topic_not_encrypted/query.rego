package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_sns_topic[name]

	not common_lib.valid_key(resource, "kms_master_key_id")

	result := {
		"documentId": doc.id,
		"resourceType": "aws_sns_topic",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_sns_topic[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "SNS Topic should be encrypted",
		"keyActualValue": "SNS Topic is not encrypted",
	}
}

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_sns_topic[name]

	resource.kms_master_key_id == ""

	result := {
		"documentId": doc.id,
		"resourceType": "aws_sns_topic",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_sns_topic[%s].kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "SNS Topic should be encrypted",
		"keyActualValue": "SNS Topic is not encrypted",
	}
}
