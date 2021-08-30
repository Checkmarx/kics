package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_ecr_repository[name]

	not common_lib.valid_key(resource, "encryption_configuration")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_ecr_repository[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The attribute 'encryption_configuration' is defined and not null",
		"keyActualValue": "The attribute 'encryption_configuration' is undefined or null",
	}
}
