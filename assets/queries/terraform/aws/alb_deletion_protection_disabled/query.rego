package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	lb := input.document[i].resource.aws_lb[name]
	not common_lib.valid_key(lb, "enable_deletion_protection")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_lb[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_lb.enable_deletion_protection is defined and not null",
		"keyActualValue": "aws_lb.enable_deletion_protection is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_lb", name], []),
	}
}

CxPolicy[result] {
	lb := input.document[i].resource.aws_lb[name]

	lb.enable_deletion_protection == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_lb[%s].enable_deletion_protection", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_lb.enable_deletion_protection is set to true",
		"keyActualValue": "aws_lb.enable_deletion_protection is set to false",
		"searchLine": common_lib.build_search_line(["resource", "aws_lb", "enable_deletion_protection", name], []),
	}
}
