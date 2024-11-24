package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_default_vpc[name]

	result := {
		"documentId": document.id,
		"resourceType": "aws_default_vpc",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_default_vpc[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_default_vpc' should not exist",
		"keyActualValue": "'aws_default_vpc' exists",
		"searchLine": common_lib.build_search_line(["resource", "aws_default_vpc", name], []),
	}
}

CxPolicy[result] {
	some document in input.document
	module := document.module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_default_vpc", "default_vpc_name")

	common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": document.id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("%s.%s", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_default_vpc' should not exist",
		"keyActualValue": "'aws_default_vpc' exists",
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck], []),
	}
}
