package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	not key_set_to_false(resource)
	not common_lib.valid_key(resource, "enable_key_rotation")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kms_key[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_kms_key[%s].enable_key_rotation is set to true", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].enable_key_rotation is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_kms_key[name]

	not key_set_to_false(resource)
	resource.enable_key_rotation == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_kms_key[%s].enable_key_rotation", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_kms_key[%s].enable_key_rotation is set to true", [name]),
		"keyActualValue": sprintf("aws_kms_key[%s].enable_key_rotation is set to false", [name]),
	}
}

key_set_to_false(resource) {
	resource.is_enabled == false
}
