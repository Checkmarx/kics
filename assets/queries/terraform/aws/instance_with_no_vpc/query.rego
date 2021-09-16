package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	not common_lib.valid_key(resource, "vpc_security_group_ids")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'vpc_security_group_ids' is defined and not null",
		"keyActualValue": "Attribute 'vpc_security_group_ids' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name], []),
	}
}


CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "vpc_security_group_ids")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'vpc_security_group_ids' is defined and not null",
		"keyActualValue": "Attribute 'vpc_security_group_ids' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}
