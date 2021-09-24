package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]
	resource.ebs_optimized == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance[{{%s}}].ebs_optimized", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ebs_optimized' is set to true",
		"keyActualValue": "'ebs_optimized' is set to false",
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name, "ebs_optimized"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "ebs_optimized")

	module[keyToCheck] == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].ebs_optimized", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'ebs_optimized' is set to true",
		"keyActualValue": "'ebs_optimized' is set to false",
		"searchLine": common_lib.build_search_line(["module", name, "ebs_optimized"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]
	not common_lib.valid_key(resource, "ebs_optimized")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ebs_optimized' is set to true",
		"keyActualValue": "'ebs_optimized' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "ebs_optimized")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'ebs_optimized' is set to true",
		"keyActualValue": "'ebs_optimized' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}
