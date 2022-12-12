package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document = input.document[i]
	resource = document.resource.aws_autoscaling_group[name]

	count(resource.load_balancers) == 0
	not has_target_group_arns(resource, "target_group_arns")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_autoscaling_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_autoscaling_group[%s].load_balancers", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_autoscaling_group[%s].load_balancers should be set and not empty", [name]),
		"keyActualValue": sprintf("aws_autoscaling_group[%s].load_balancers is empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_autoscaling_group", name, "load_balancers"], []),
	}
}

CxPolicy[result] {
	document = input.document[i]
	resource = document.resource.aws_autoscaling_group[name]

	not common_lib.valid_key(resource, "load_balancers")
	not has_target_group_arns(resource, "target_group_arns")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_autoscaling_group",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_autoscaling_group[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_autoscaling_group[%s].load_balancers should be set and not empty", [name]),
		"keyActualValue": sprintf("aws_autoscaling_group[%s].load_balancers is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_autoscaling_group", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_autoscaling_group", "load_balancers")
	keyToCheckGroupArns := common_lib.get_module_equivalent_key("aws", module.source, "aws_autoscaling_group", "target_group_arns")

	not has_target_group_arns(module, keyToCheckGroupArns)
	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'load_balancers' should be set and not empty",
		"keyActualValue": "'load_balancers' is undefined",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_autoscaling_group", "load_balancers")
	keyToCheckGroupArns := common_lib.get_module_equivalent_key("aws", module.source, "aws_autoscaling_group", "target_group_arns")

	not has_target_group_arns(module, keyToCheckGroupArns)
	count(module[keyToCheck]) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].load_balancers", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'load_balancers' should be set and not empty",
		"keyActualValue": "'load_balancers' is undefined",
		"searchLine": common_lib.build_search_line(["module", name, "load_balancers"], []),
	}
}

has_target_group_arns(resource, key){
	not is_array(resource[key])
	resource[key] != ""
} else{
	is_array(resource[key])
	count(resource[key]) > 0
}
