package Cx

import data.generic.common as common_lib

lbs := {"aws_lb", "aws_alb"}

CxPolicy[result] {
	loadBalancer := lbs[l]
	lb := input.document[i].resource[loadBalancer][name]

	not common_lib.valid_key(lb, "enable_deletion_protection")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s]", [loadBalancer, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'enable_deletion_protection' is defined and set to true",
		"keyActualValue": "'enable_deletion_protection' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", loadBalancer, name], []),
	}
}

CxPolicy[result] {
	loadBalancer := lbs[l]
	lb := input.document[i].resource[loadBalancer][name]

	lb.enable_deletion_protection == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].enable_deletion_protection", [loadBalancer, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'enable_deletion_protection' is set to true",
		"keyActualValue": "'enable_deletion_protection' is set to false",
		"searchLine": common_lib.build_search_line(["resource", loadBalancer, name, "enable_deletion_protection"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_lb", "enable_deletion_protection")

	not common_lib.valid_key(module, "enable_deletion_protection")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'enable_deletion_protection' is defined and set to true",
		"keyActualValue": "'enable_deletion_protection' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_lb", "enable_deletion_protection")

	module.enable_deletion_protection == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].enable_deletion_protection", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'enable_deletion_protection' is set to true",
		"keyActualValue": "'enable_deletion_protection' is set to false",
		"searchLine": common_lib.build_search_line(["module", name, "enable_deletion_protection"], []),
	}
}
