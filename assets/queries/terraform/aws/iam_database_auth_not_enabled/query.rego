package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	resource.iam_database_authentication_enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s].iam_database_authentication_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'iam_database_authentication_enabled' is set to true",
		"keyActualValue": "'iam_database_authentication_enabled' is set to false",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "iam_database_authentication_enabled"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "iam_database_authentication_enabled")

	module[keyToCheck] == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].iam_database_authentication_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'iam_database_authentication_enabled' is set to true",
		"keyActualValue": "'iam_database_authentication_enabled' is set to false",
		"searchLine": common_lib.build_search_line(["module", name, "iam_database_authentication_enabled"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	not common_lib.valid_key(resource, "iam_database_authentication_enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'iam_database_authentication_enabled' is set to true",
		"keyActualValue": "'iam_database_authentication_enabled' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "iam_database_authentication_enabled")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'iam_database_authentication_enabled' is set to true",
		"keyActualValue": "'iam_database_authentication_enabled' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}
