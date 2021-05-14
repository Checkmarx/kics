package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudwatch_log_group[name]
	object.get(resource, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("cloudwatch_log_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'kms_key_id' is set",
		"keyActualValue": "Attribute 'kms_key_id' is undefined",
	}
}
