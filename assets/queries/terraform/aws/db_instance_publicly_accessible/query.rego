package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_db_instance[name]
	resource.publicly_accessible

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s].publicly_accessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'publicly_accessible' is set to false or undefined",
		"keyActualValue": "'publicly_accessible' is set to true",
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "publicly_accessibled"], []),
	}
}


CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_db_instance", "publicly_accessible")
	module[keyToCheck]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].publicly_accessible", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'publicly_accessible' is set to false or undefined",
		"keyActualValue": "'publicly_accessible' is set to true",
		"searchLine": common_lib.build_search_line(["module", name, "publicly_accessible"], []),
	}
}
