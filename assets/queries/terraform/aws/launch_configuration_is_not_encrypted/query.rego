package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_launch_configuration[name]
	resource[block].encrypted == false

	not contains(block, "ephemeral")
	contains(block, "block_device")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_launch_configuration[%s].%s.encrypted", [name, block]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_launch_configuration[%s].%s.encrypted is true", [name, block]),
		"keyActualValue": sprintf("aws_launch_configuration[%s].%s.encrypted is false", [name, block]),
		"searchLine": common_lib.build_search_line(["resource", "aws_launch_configuration", name, block, "encrypted"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_launch_configuration[name]
	resourceBlock := resource[block]
	not common_lib.valid_key(resourceBlock, "encrypted")

	not contains(block, "ephemeral")
	contains(block, "block_device")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_launch_configuration[%s].%s", [name, block]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_launch_configuration[%s].%s.encrypted is set", [name, block]),
		"keyActualValue": sprintf("aws_launch_configuration[%s].%s.encrypted is undefined", [name, block]),
		"searchLine": common_lib.build_search_line(["resource", "aws_launch_configuration", name, block], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_launch_configuration", "root_block_device")
	module[block].encrypted == false

	not contains(block, "ephemeral")
	contains(block, "block_device")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].%s.encrypted", [name, block]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'encrypted' is true",
		"keyActualValue": "'encrypted' is false",
		"searchLine": common_lib.build_search_line(["module", name, block, "encrypted"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_launch_configuration", "root_block_device")
	moduleBlock := module[block]
	not common_lib.valid_key(moduleBlock, "encrypted")

	not contains(block, "ephemeral")
	contains(block, "block_device")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].%s", [name, block]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'encrypted' is set",
		"keyActualValue": "'encrypted' is undefined",
		"searchLine": common_lib.build_search_line(["module", name, block], []),
	}
}
