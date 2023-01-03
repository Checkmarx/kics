package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	resource.auto_minor_version_upgrade == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_db_instance",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_db_instance[%s].auto_minor_version_upgrade", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name,"auto_minor_version_upgrade"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'auto_minor_version_upgrade' should be set to true",
		"keyActualValue": "'auto_minor_version_upgrade' is set to false",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "auto_minor_version_upgrade")

	module[keyToCheck] == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].auto_minor_version_upgrade", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'auto_minor_version_upgrade' should be set to true",
		"keyActualValue": "'auto_minor_version_upgrade' is set to false",
		"searchLine": common_lib.build_search_line(["module", name, "auto_minor_version_upgrade"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
