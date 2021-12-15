package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.resource.aws_instance[name]

	sgs := {"security_groups", "vpc_security_group_ids"}

	sgInfo := resource[sgs[s]][_]

	contains(lower(sgInfo), "default")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("aws_instance[%s].%s", [name, sgs[s]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_instance[%s].%s is not using default security group", [name, s]),
		"keyActualValue": sprintf("aws_instance[%s].%s is using at least one default security group", [name, s]),
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name, sgs[s]], []),
	}
}
