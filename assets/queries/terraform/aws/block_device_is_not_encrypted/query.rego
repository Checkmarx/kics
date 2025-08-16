package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

supported_resources := {"aws_launch_configuration", "aws_instance"}

CxPolicy[result] {
	resource := input.document[i].resource[supported_resources[type]][name]
	
	resourceBlock := resource[block]
    is_false(resourceBlock.encrypted)

	valid_block(block)

	result := {
		"documentId": input.document[i].id,
		"resourceType": supported_resources[type],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.encrypted", [supported_resources[type], name, block]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.encrypted should be true", [supported_resources[type], name, block]),
		"keyActualValue": sprintf("%s[%s].%s.encrypted is false", [supported_resources[type], name, block]),
		"searchLine": common_lib.build_search_line(["resource", supported_resources[type], name, block, "encrypted"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[supported_resources[type]][name]
	resourceBlock := resource[block]
	not common_lib.valid_key(resourceBlock, "encrypted")

	valid_block(block)

	result := {
		"documentId": input.document[i].id,
		"resourceType": supported_resources[type],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s", [supported_resources[type], name, block]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].%s.encrypted should be set", [supported_resources[type], name, block]),
		"keyActualValue": sprintf("%s[%s].%s.encrypted is undefined", [supported_resources[type], name, block]),
		"searchLine": common_lib.build_search_line(["resource", supported_resources[type], name, block], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]

	[_, value] := walk(module)

	target_block := value[block][idx]
	res := prepare_issue_launch_configuration_module(target_block, block, name, idx, module.source)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": res["sk"],
		"issueType": res["it"],
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"searchLine": res["sl"],
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]

	[_, value] := walk(module)
	
	target_block := value[block]
	res := prepare_issue_instance_module(target_block, block, name, module.source)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": res["sk"],
		"issueType": res["it"],
		"keyExpectedValue": res["kev"],
		"keyActualValue": res["kav"],
		"searchLine": res["sl"],
	}
}

prepare_issue_launch_configuration_module(target_block, block, name, idx, module_source) = res {
	is_false(target_block.encrypted)
	common_lib.get_module_equivalent_key("aws", module_source, "aws_launch_configuration", block)

	valid_block(block)

	res := {
		"sk": sprintf("module[%s].%s.encrypted", [name, block]),
		"it": "IncorrectValue",
		"kev": "'encrypted' should be true",
		"kav": "'encrypted' is false",
		"sl": common_lib.build_search_line(["module", name, block, idx], ["encrypted"]),
	}
} else = res {
	not common_lib.valid_key(target_block, "encrypted")
	common_lib.get_module_equivalent_key("aws", module_source, "aws_launch_configuration", block)

	valid_block(block)

	res := {
		"sk": sprintf("module[%s].%s", [name, block]),
		"it": "MissingAttribute",
		"kev": "'encrypted' should be defined",
		"kav": "'encrypted' is undefined",
		"sl": common_lib.build_search_line(["module", name, block], [idx]),
	}
}

prepare_issue_instance_module(target_block, block, name, module_source) = res {
	not common_lib.valid_key(target_block, "encrypted")

	common_lib.get_module_equivalent_key("aws", module_source, "aws_instance", block)

	valid_block(block)

	res := {
		"sk": sprintf("module[%s].%s", [name, block]),
		"it": "MissingAttribute",
		"kev": "'encrypted' should be defined",
		"kav": "'encrypted' is undefined",
		"sl": common_lib.build_search_line(["module", name, block], []),
	}
} else = res {
	is_false(target_block.encrypted)

	common_lib.get_module_equivalent_key("aws", module_source, "aws_instance", block)

	valid_block(block)

	res := {
		"sk": sprintf("module[%s].%s.encrypted", [name, block]),
		"it": "IncorrectValue",
		"kev": "'encrypted' should be true",
		"kav": "'encrypted' is false",
		"sl": common_lib.build_search_line(["module", name, block], ["encrypted"]),
	}
}

valid_block(block) {
	not contains(block, "ephemeral")
	contains(block, "block_device")
}

is_false(field) {
	field == false
} else {
	lower(field) == "false"
}