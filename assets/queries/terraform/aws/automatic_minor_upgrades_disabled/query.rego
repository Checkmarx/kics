package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	resource.auto_minor_version_upgrade == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s].auto_minor_version_upgrade", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'auto_minor_version_upgrade' is set to true",
		"keyActualValue": "'auto_minor_version_upgrade' is set to false",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "auto_minor_version_upgrade"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "auto_minor_version_upgrade")

	module[keyToCheck] == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].auto_minor_version_upgrade", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'auto_minor_version_upgrade' is set to true",
		"keyActualValue": "'auto_minor_version_upgrade' is set to false",
		"searchLine": common_lib.build_search_line(["module", name, "auto_minor_version_upgrade"], []),
	}
}
