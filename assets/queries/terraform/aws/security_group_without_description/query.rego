package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_security_group[name]
	not common_lib.valid_key(resource, "description")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_security_group[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_security_group[{{%s}}] description is defined and not null", [name]),
		"keyActualValue": sprintf("aws_security_group[{{%s}}] description is undefined or null", [name]),
	}
}
