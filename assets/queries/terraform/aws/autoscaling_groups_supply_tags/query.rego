package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	auto := input.document[i].resource.aws_autoscaling_group[name]
	not common_lib.valid_key(auto, "tags")
	not common_lib.valid_key(auto, "tag")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_autoscaling_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'tags' or 'tag' are defined and not null",
		"keyActualValue": "'tags' or 'tag' are undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_autoscaling_group", name], []),
	}
}
