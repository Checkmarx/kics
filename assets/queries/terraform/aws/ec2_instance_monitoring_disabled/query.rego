package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	not common_lib.valid_key(resource, "monitoring")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance.{{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'monitoring' is defined and not null", [name]),
		"keyActualValue": sprintf("'monitoring' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "monitoring")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'monitoring' is defined and not null", [name]),
		"keyActualValue": sprintf("'monitoring' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	resource.monitoring == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance.{{%s}}.monitoring", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'monitoring' is set to true", [name]),
		"keyActualValue": sprintf("'monitoring' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name, "monitoring"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "monitoring")

	module[keyToCheck] == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].monitoring", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'monitoring' is set to true", [name]),
		"keyActualValue": sprintf("'monitoring' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["module", name, "monitoring"], []),
	}
}

