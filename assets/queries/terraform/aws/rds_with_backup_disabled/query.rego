package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	db := input.document[i].resource.aws_db_instance[name]
	db.backup_retention_period == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(db, name),
		"searchKey": sprintf("aws_db_instance[%s].backup_retention_period", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'backup_retention_period' should not equal '0'",
		"keyActualValue": "'backup_retention_period' is equal '0'",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "backup_retention_period"], []),
		"remediation": json.marshal({
			"before": "0",
			"after": "12"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "backup_retention_period")

	module[keyToCheck] == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].backup_retention_period", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'backup_retention_period' should not equal '0'",
		"keyActualValue": "'backup_retention_period' is equal '0'",
		"searchLine": common_lib.build_search_line(["module", name, "backup_retention_period"], []),
		"remediation": json.marshal({
			"before": "0",
			"after": "12"
		}),
		"remediationType": "replacement",
	}
}
