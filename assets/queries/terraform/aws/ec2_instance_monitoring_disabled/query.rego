package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	not common_lib.valid_key(resource, "monitoring")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance.{{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_instance.%s.monitoring should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_instance.%s.monitoring is undefined or null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	resource.monitoring == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance.{{%s}}.monitoring", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_instance.%s.monitoring should be true", [name]),
		"keyActualValue": sprintf("aws_instance.%s.monitoring is false", [name]),
	}
}
