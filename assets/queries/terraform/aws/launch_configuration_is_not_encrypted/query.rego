package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_launch_configuration[name]
	resource[block].encrypted == false

	valid_block(block)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_launch_configuration",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_launch_configuration[%s].%s.encrypted", [name, block]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_launch_configuration[%s].%s.encrypted should be true", [name, block]),
		"keyActualValue": sprintf("aws_launch_configuration[%s].%s.encrypted is false", [name, block]),
		"searchLine": common_lib.build_search_line(["resource", "aws_launch_configuration", name, block, "encrypted"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_launch_configuration[name]
	resourceBlock := resource[block]
	not common_lib.valid_key(resourceBlock, "encrypted")

	valid_block(block)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_launch_configuration",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_launch_configuration[%s].%s", [name, block]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_launch_configuration[%s].%s.encrypted should be set", [name, block]),
		"keyActualValue": sprintf("aws_launch_configuration[%s].%s.encrypted is undefined", [name, block]),
		"searchLine": common_lib.build_search_line(["resource", "aws_launch_configuration", name, block], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]

	[path, value] := walk(module)
    value[block][idx].encrypted == false

	common_lib.get_module_equivalent_key("aws", module.source, "aws_launch_configuration", block)

	valid_block(block)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s.encrypted", [name, block]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'encrypted' should be true",
		"keyActualValue": "'encrypted' is false",
		"searchLine": common_lib.build_search_line(["module", name, block, idx], ["encrypted"]),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]

	[path, value] := walk(module)

	v := value[block][idx]
	not common_lib.valid_key(v, "encrypted")

	common_lib.get_module_equivalent_key("aws", module.source, "aws_launch_configuration", block)

	valid_block(block)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s", [name, block]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'encrypted' should be set",
		"keyActualValue": "'encrypted' is undefined",
		"searchLine": common_lib.build_search_line(["module", name, block], [idx]),
	}
}


valid_block(block) {
	not contains(block, "ephemeral")
	contains(block, "block_device")
}
