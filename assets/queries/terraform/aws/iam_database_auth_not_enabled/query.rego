package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	resource.iam_database_authentication_enabled == false
	common_lib.valid_for_iam_engine_and_version_check(resource, "engine", "engine_version", "instance_class")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_instance[%s].iam_database_authentication_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'iam_database_authentication_enabled' should be set to true",
		"keyActualValue": "'iam_database_authentication_enabled' is set to false",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "iam_database_authentication_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "iam_database_authentication_enabled")

	module[keyToCheck] == false

	common_lib.valid_for_iam_engine_and_version_check(module, "engine", "engine_version", "instance_class")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].iam_database_authentication_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'iam_database_authentication_enabled' should be set to true",
		"keyActualValue": "'iam_database_authentication_enabled' is set to false",
		"searchLine": common_lib.build_search_line(["module", name, "iam_database_authentication_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	not common_lib.valid_key(resource, "iam_database_authentication_enabled")
	common_lib.valid_for_iam_engine_and_version_check(resource, "engine", "engine_version", "instance_class")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_instance[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'iam_database_authentication_enabled' should be set to true",
		"keyActualValue": "'iam_database_authentication_enabled' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name], []),
		"remediation": "iam_database_authentication_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "iam_database_authentication_enabled")

	not common_lib.valid_key(module, keyToCheck)

	common_lib.valid_for_iam_engine_and_version_check(module, "engine", "engine_version", "instance_class")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'iam_database_authentication_enabled' should be set to true",
		"keyActualValue": "'iam_database_authentication_enabled' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
		"remediation": "iam_database_authentication_enabled = true",
		"remediationType": "addition",
	}
}
