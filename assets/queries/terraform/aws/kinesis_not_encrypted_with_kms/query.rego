package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_kinesis_stream[name]

	not resource.encryption_type

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kinesis_stream[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_kinesis_stream[%s].encryption_type is set", [name]),
		"keyActualValue": sprintf("aws_kinesis_stream[%s].encryption_type is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_kinesis_stream[name]

	resource.encryption_type == "NONE"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kinesis_stream[%s].encryption_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_kinesis_stream[%s].encryption_type is set and not NONE", [name]),
		"keyActualValue": sprintf("aws_kinesis_stream[%s].encryption_type is set but NONE", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_kinesis_stream[name]

	resource.encryption_type == "KMS"

	not resource.kms_key_id

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kinesis_stream[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_kinesis_stream[%s].kms_key_id is set", [name]),
		"keyActualValue": sprintf("aws_kinesis_stream[%s].kms_key_id is undefined", [name]),
	}
}
