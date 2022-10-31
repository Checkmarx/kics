package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

validTypes := {"profiler", "audit"}

validTypeConcat := concat(", ", validTypes)

CxPolicy[result] {
	resource := input.document[i].resource.aws_docdb_cluster[name]
	not exist(resource, "enabled_cloudwatch_logs_exports")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_docdb_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_docdb_cluster[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_docdb_cluster.enabled_cloudwatch_logs_exports should be defined",
		"keyActualValue": "aws_docdb_cluster.enabled_cloudwatch_logs_exports is undefined",
	}
}

CxPolicy[result] {
	logs := input.document[i].resource.aws_docdb_cluster[name].enabled_cloudwatch_logs_exports
	tf_lib.empty_array(logs)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_docdb_cluster",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.aws_docdb_cluster[name], name),
		"searchKey": sprintf("aws_docdb_cluster[{{%s}}].enabled_cloudwatch_logs_exports", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_docdb_cluster.enabled_cloudwatch_logs_exports should have all following values: %s", [validTypeConcat]),
		"keyActualValue": "aws_docdb_cluster.enabled_cloudwatch_logs_exports is empty",
	}
}

CxPolicy[result] {
	logs := input.document[i].resource.aws_docdb_cluster[name].enabled_cloudwatch_logs_exports
	not tf_lib.empty_array(logs)

	logsSet := {log | log := logs[_]}
	missingTypes := validTypes - logsSet

	count(missingTypes) > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_docdb_cluster",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.aws_docdb_cluster[name], name),
		"searchKey": sprintf("aws_docdb_cluster[{{%s}}].enabled_cloudwatch_logs_exports", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_docdb_cluster.enabled_cloudwatch_logs_exports should have all following values: %s", [validTypeConcat]),
		"keyActualValue": sprintf("aws_docdb_cluster.enabled_cloudwatch_logs_exports has the following missing values: %s", [concat(", ", missingTypes)]),
	}
}

exist(obj, key) {
	_ = obj[key]
}
