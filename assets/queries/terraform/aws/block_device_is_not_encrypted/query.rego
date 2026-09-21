package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

supported_resources := {"aws_launch_configuration", "aws_instance"}

CxPolicy[result] {
	resource := input.document[i].resource[supported_resources[type]][name]
	resourceBlock := resource[block]

	res := is_false_or_undefined(resourceBlock,block,supported_resources[type],name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": supported_resources[type],
		"resourceName": tf_lib.get_resource_name(resource, name),
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

	target_block := get_as_array(value[block])[idx]
	res := prepare_issue_launch_configuration_module(target_block, block, name, idx, module.source, is_array(value[block]))

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

is_false_or_undefined(resourceBlock,block,type,name) = res {

    resourceBlock.encrypted == false
	valid_block(block)

	res := {
		"sk": sprintf("%s[%s].%s.encrypted", [supported_resources[type], name, block]),
		"it": "IncorrectValue",
		"kev": sprintf("%s[%s].%s.encrypted should be true", [supported_resources[type], name, block]),
		"kav": sprintf("%s[%s].%s.encrypted is false", [supported_resources[type], name, block]),
		"sl": common_lib.build_search_line(["resource", supported_resources[type], name, block, "encrypted"], []),
	}
} else = res {

	not common_lib.valid_key(resourceBlock, "encrypted")
	valid_block(block)
	res := {
		"sk": sprintf("%s[%s].%s", [supported_resources[type], name, block]),
		"it": "MissingAttribute",
		"kev": sprintf("%s[%s].%s.encrypted should be set", [supported_resources[type], name, block]),
		"kav": sprintf("%s[%s].%s.encrypted is undefined", [supported_resources[type], name, block]),
		"sl": common_lib.build_search_line(["resource", supported_resources[type], name, block], []),
	}
}

prepare_issue_launch_configuration_module(target_block, block, name, idx, module_source,is_array) = res {
	is_array
	results := is_not_encrypted(target_block,name,block,idx)
	common_lib.get_module_equivalent_key("aws", module_source, supported_resources[i2], block)

	valid_block(block)

	res := {
		"sk": results.searchKey,
		"it": "IncorrectValue",
		"kev": "'encrypted' should be true",
		"kav": "'encrypted' is false",
		"sl": results.searchLine,
	}
} else = res {
	is_array
	results := undefined_encrypted_field(target_block,name,block,idx)
	common_lib.get_module_equivalent_key("aws", module_source, supported_resources[i2], block)

	valid_block(block)

	res := {
		"sk": results.searchKey,
		"it": "IncorrectValue",
		"kev": "'encrypted' should be defined",
		"kav": "'encrypted' is undefined",
		"sl": results.searchLine,
	}

} else = res {
	not is_array
	target_block.encrypted == false
	common_lib.get_module_equivalent_key("aws", module_source, supported_resources[i2], block)

	valid_block(block)

	res := {
		"sk": sprintf("module[%s].%s.encrypted", [name, block]),
		"it": "IncorrectValue",
		"kev": "'encrypted' should be true",
		"kav": "'encrypted' is false",
		"sl": common_lib.build_search_line(["module", name, block, "encrypted"], []),
	}
} else = res {
	not is_array
	not common_lib.valid_key(target_block, "encrypted")
	common_lib.get_module_equivalent_key("aws", module_source, supported_resources[i2], block)

	valid_block(block)

	res := {
		"sk": sprintf("module[%s].%s", [name, block]),
		"it": "MissingAttribute",
		"kev": "'encrypted' should be defined",
		"kav": "'encrypted' is undefined",
		"sl": common_lib.build_search_line(["module", name, block], []),
	}
}

valid_block(block) {
	not contains(block, "ephemeral")
	contains(block, "block_device")
}

get_as_array(value) = res {
	is_array(value)
	res := value
} else = [value]

is_not_encrypted(target_block,name,block,idx) = results {
	target_block.encrypted == false
	results := {
		"searchKey": sprintf("module[%s].%s.%d.encrypted", [name, block, idx]),
		"searchLine": common_lib.build_search_line(["module", name, block, idx, "encrypted"], []),
	}
} else = results {
	target_block.ebs.encrypted == false
	results := {
		"searchKey": sprintf("module[%s].%s.%d.ebs.encrypted", [name, block, idx]), #does not point to encrypted due to search limitations
		"searchLine": common_lib.build_search_line(["module", name, block, idx, "ebs", "encrypted"], []),
	}
}

undefined_encrypted_field(target_block,name,block,idx) = results {
	common_lib.valid_key(target_block, "ebs")
	not common_lib.valid_key(target_block.ebs, "encrypted")
	results := {
		"searchKey": sprintf("module[%s].%s.%d.ebs", [name, block, idx]),
		"searchLine": common_lib.build_search_line(["module", name, block, idx, "ebs"], []),
	}
} else = results {
	not common_lib.valid_key(target_block, "ebs")
	not common_lib.valid_key(target_block, "encrypted")
	results := {
		"searchKey": sprintf("module[%s].%s.%d", [name, block, idx]),
		"searchLine": common_lib.build_search_line(["module", name, block, idx], []),
	}
}
