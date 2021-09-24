package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elb[name]
	not common_lib.valid_key(resource, "access_logs")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elb[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_elb[{{%s}}].access_logs' is defined and not null", [name]),
		"keyActualValue": sprintf("'aws_elb[{{%s}}].access_logs' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elb", name], []),
	}
}

CxPolicy[result] {
	logsEnabled := input.document[i].resource.aws_elb[name].access_logs.enabled
	logsEnabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_elb[{{%s}}].access_logs.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_elb[{{%s}}].access_logs.enabled' is true", [name]),
		"keyActualValue": sprintf("'aws_elb[{{%s}}].access_logs.enabled' is false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elb", name, "access_logs", "enabled"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_elb", "access_logs")
	not common_lib.valid_key(module, "access_logs")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'access_logs' is defined and not null",
		"keyActualValue": "'access_logs' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_elb", "access_logs")
	logsEnabled := input.document[i].module[name].access_logs.enabled
	logsEnabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].access_logs.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'access_logs.enabled' is true",
		"keyActualValue": "'access_logs.enabled' is false",
		"searchLine": common_lib.build_search_line(["module", name, "access_logs", "enabled"], []),
	}
}
