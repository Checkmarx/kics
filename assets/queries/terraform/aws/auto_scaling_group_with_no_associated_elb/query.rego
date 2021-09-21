package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document = input.document[i]
	resource = document.resource.aws_autoscaling_group[name]

	not common_lib.valid_key(resource, "load_balancers")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_autoscaling_group[%s].load_balancers", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_autoscaling_group[%s].load_balancers is set and not empty", [name]),
		"keyActualValue": sprintf("aws_autoscaling_group[%s].load_balancers is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_autoscaling_group", name, "load_balancers"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_autoscaling_group", "load_balancers")

	not common_lib.valid_key(module, "load_balancers")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].load_balancers", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'load_balancers' is set and not empty",
		"keyActualValue": "'loas_balancers' is undefined",
		"searchLine": common_lib.build_search_line(["module", name, "load_balancers"], []),
	}
}
