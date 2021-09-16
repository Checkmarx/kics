package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	instance := input.document[i].resource.aws_instance[name]
	containsAccessKey(instance.user_data)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_instance[%s].user_data", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'user_data' doesn't contain hardcoded access key",
		"keyActualValue": "'user_data' contains hardcoded access key",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_instance", "user_data")

	containsAccessKey(module[keyToCheck])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].user_data", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'user_data' doesn't contain hardcoded access key",
		"keyActualValue": "'user_data' contains hardcoded access key",
	}
}

containsAccessKey(user_data) {
	re_match("([^A-Z0-9])[A-Z0-9]{20}([^A-Z0-9])", user_data)
}

containsAccessKey(user_data) {
	re_match("[A-Za-z0-9/+=]{40}([^A-Za-z0-9/+=])", user_data)
}
