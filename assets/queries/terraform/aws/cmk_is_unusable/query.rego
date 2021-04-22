package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	resource.is_enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kms_key[%s].is_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_kms_key[%s].is_enabled is set to true", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].is_enabled is set to false", [name]),
	}
}
