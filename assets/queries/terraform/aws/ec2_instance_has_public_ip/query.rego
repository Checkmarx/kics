package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	not common_lib.valid_key(resource, "associate_public_ip_address")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'associate_public_ip_address' is defined and not null",
		"keyActualValue": "'associate_public_ip_address' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "associate_public_ip_address")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'associate_public_ip_address' is defined and not null",
		"keyActualValue": "'associate_public_ip_address' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_instance[name]

	isTrue(resource.associate_public_ip_address)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance.%s.associate_public_ip_address", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'associate_public_ip_address' is false",
		"keyActualValue": "'associate_public_ip_address' is true",
		"searchLine": common_lib.build_search_line(["resource", "aws_instance", name, "associate_public_ip_address"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "associate_public_ip_address")

	isTrue(module[keyToCheck])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].associate_public_ip_address", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'associate_public_ip_address' is false",
		"keyActualValue": "'associate_public_ip_address' is true",
		"searchLine": common_lib.build_search_line(["module", name, "associate_public_ip_address"], []),
	}
}

isTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}
