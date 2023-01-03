package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_elb[name]
	not common_lib.valid_key(resource, "access_logs")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elb",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_elb[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_elb[{{%s}}].access_logs' should be defined and not null", [name]),
		"keyActualValue": sprintf("'aws_elb[{{%s}}].access_logs' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elb", name], []),
		"remediation": "access_logs {\n\t\tenabled = true\n\t}",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_elb[name]
	logsEnabled := resource.access_logs.enabled
	logsEnabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_elb",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_elb[{{%s}}].access_logs.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_elb[{{%s}}].access_logs.enabled' should be true", [name]),
		"keyActualValue": sprintf("'aws_elb[{{%s}}].access_logs.enabled' is false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_elb", name, "access_logs", "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_elb", "access_logs")
	not common_lib.valid_key(module, keyToCheck)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'access_logs' should be defined and not null",
		"keyActualValue": "'access_logs' is undefined or null",
		"searchLine": common_lib.build_search_line(["module", name], []),
		"remediation": sprintf("%s {\n\t\tenabled = true\n\t}", [keyToCheck]),
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_elb", "access_logs")
	logsEnabled := input.document[i].module[name]
	logsEnabled[keyToCheck].enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].%s.enabled", [name, keyToCheck]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'access_logs.enabled' should be true",
		"keyActualValue": "'access_logs.enabled' is false",
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck, "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
