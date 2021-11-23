package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	db := input.document[i].resource.aws_db_instance[name]

	enginePort := common_lib.engines[e]

	db.engine == e
	db.port == enginePort

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_db_instance[%s].port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_db_instance[%s].port is not set to %d", [name, enginePort]),
		"keyActualValue": sprintf("aws_db_instance[%s].port is set to %d", [name, enginePort]),
		"searchLine": common_lib.build_search_line(["resource", "aws_db_instance", name, "port"], []),
	}
}
