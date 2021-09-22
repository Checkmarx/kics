package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	db := input.document[i].resource.aws_db_instance[name]

	not common_lib.valid_key(db, "backup_retention_period")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'backup_retention_period' exists",
		"keyActualValue": "'backup_retention_period' is missing",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "backup_retention_period")

	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'backup_retention_period' exists",
		"keyActualValue": "'backup_retention_period' is missing",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

CxPolicy[result] {
	db := input.document[i].resource.aws_db_instance[name]
	db.backup_retention_period == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s].backup_retention_period", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'backup_retention_period' is not equal '0'",
		"keyActualValue": "'backup_retention_period' is equal '0'",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "backup_retention_period"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "backup_retention_period")

	module[keyToCheck] == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].backup_retention_period", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'backup_retention_period' is not equal '0'",
		"keyActualValue": "'backup_retention_period' is equal '0'",
		"searchLine": common_lib.build_search_line(["module", name, "backup_retention_period"], []),
	}
}
