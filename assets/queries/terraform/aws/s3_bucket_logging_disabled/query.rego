package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	s3 := input.document[i].resource.aws_s3_bucket[name]
	not common_lib.valid_key(s3, "logging")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'logging' is defined and not null",
		"keyActualValue": "'logging' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_s3_bucket", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_s3_bucket", "logging")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'logging' is defined and not null",
		"keyActualValue": "'logging' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}
