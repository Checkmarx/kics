package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	db := input.document[i].resource.aws_db_instance[name]

	not db.enabled_cloudwatch_logs_exports

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(db, name),
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'enabled_cloudwatch_logs_exports' should be defined",
		"keyActualValue": "'enabled_cloudwatch_logs_exports' is undefined",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name], []),
	}
}

CxPolicy[result] {
	db := input.document[i].resource.aws_db_instance[name]

	count(db.enabled_cloudwatch_logs_exports) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(db, name),
		"searchKey": sprintf("aws_db_instance[%s].enabled_cloudwatch_logs_exports", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'enabled_cloudwatch_logs_exports' has one or more values",
		"keyActualValue": "'enabled_cloudwatch_logs_exports' is empty",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "enabled_cloudwatch_logs_exports"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "enabled_cloudwatch_logs_exports")
	not module[keyToCheck]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'enabled_cloudwatch_logs_exports' should be defined",
		"keyActualValue": "'enabled_cloudwatch_logs_exports' is undefined",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "enabled_cloudwatch_logs_exports")
	count(module[keyToCheck]) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].enabled_cloudwatch_logs_exports", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'enabled_cloudwatch_logs_exports' has one or more values",
		"keyActualValue": "'enabled_cloudwatch_logs_exports' is empty",
		"searchLine": common_lib.build_search_line(["module", name, "enabled_cloudwatch_logs_exports"], []),
	}
}
