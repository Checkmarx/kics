package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue[name]
	object.get(resource, "kms_master_key_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue[%s].kms_master_key_id", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'aws_sqs_queue.kms_master_key_id' is set",
		"keyActualValue": "'aws_sqs_queue.kms_master_key_id' is undefined",
	}
}
