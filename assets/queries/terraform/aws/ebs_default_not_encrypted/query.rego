package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	encryption := input.document[i].resource.aws_ebs_encryption_by_default[name]

	not common_lib.valid_key(encryption, "enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ebs_encryption_by_default[%s].enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_ebs_encryption_by_default.enabled is defined and not null",
		"keyActualValue": "aws_ebs_encryption_by_default.enabled is undefined or null",
		"searchLine": "enabled",
	}
}

CxPolicy[result] {
	encryption := input.document[i].resource.aws_ebs_encryption_by_default[name]

	common_lib.valid_key(encryption, "enabled")
	encryption.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ebs_encryption_by_default[%s].enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_ebs_encryption_by_default.enabled is set to true",
		"keyActualValue": "aws_ebs_encryption_by_default.enabled is set to false",
		"searchLine": ["enabled"],
	}
}
