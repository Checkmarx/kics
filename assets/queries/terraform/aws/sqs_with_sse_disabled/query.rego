package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue[name]
	not common_lib.valid_key(resource, "kms_master_key_id")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_sqs_queue.kms_master_key_id is defined and not null",
		"keyActualValue": "aws_sqs_queue.kms_master_key_id is undefined or null",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue[name]
	resource.kms_master_key_id == ""

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue[%s].kms_master_key_id", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_sqs_queue.kms_master_key_id is not ''",
		"keyActualValue": "aws_sqs_queue.kms_master_key_id is ''",
	}
}
