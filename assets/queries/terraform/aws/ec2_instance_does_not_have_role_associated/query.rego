package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_instance[name]

	not common_lib.valid_key(resource, "iam_instance_profile")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_instance[%s].iam_instance_profile should be defined", [name]),
		"keyActualValue": sprintf("aws_instance[%s].iam_instance_profile is undefined", [name]),
	}
}
