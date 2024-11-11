package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

validTypes := {"audit"}

validTypeConcat := concat(", ", validTypes)

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_neptune_cluster[name]
	not exist(resource, "enable_cloudwatch_logs_exports")

	result := {
		"documentId": doc.id,
		"resourceType": "aws_neptune_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_neptune_cluster[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_neptune_cluster.enable_cloudwatch_logs_exports should be defined",
		"keyActualValue": "aws_neptune_cluster.enable_cloudwatch_logs_exports is undefined",
	}
}

CxPolicy[result] {
	some doc in input.document
	logs := doc.resource.aws_neptune_cluster[name].enable_cloudwatch_logs_exports
	tf_lib.empty_array(logs)

	result := {
		"documentId": doc.id,
		"resourceType": "aws_neptune_cluster",
		"resourceName": tf_lib.get_resource_name(doc.resource.aws_neptune_cluster[name], name),
		"searchKey": sprintf("aws_neptune_cluster[{{%s}}].enable_cloudwatch_logs_exports", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_neptune_cluster.enable_cloudwatch_logs_exports should have all following values: %s", [validTypeConcat]),
		"keyActualValue": "aws_neptune_cluster.enable_cloudwatch_logs_exports is empty",
	}
}

CxPolicy[result] {
	some doc in input.document
	logs := doc.resource.aws_neptune_cluster[name].enable_cloudwatch_logs_exports
	not tf_lib.empty_array(logs)

	logsSet := {log | log := logs[_]}
	missingTypes := validTypes - logsSet

	count(missingTypes) > 0

	result := {
		"documentId": doc.id,
		"resourceType": "aws_neptune_cluster",
		"resourceName": tf_lib.get_resource_name(doc.resource.aws_neptune_cluster[name], name),
		"searchKey": sprintf("aws_neptune_cluster[{{%s}}].enable_cloudwatch_logs_exports", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_neptune_cluster.enable_cloudwatch_logs_exports should have all following values: %s", [validTypeConcat]),
		"keyActualValue": sprintf("aws_neptune_cluster.enable_cloudwatch_logs_exports has the following missing values: %s", [concat(", ", missingTypes)]),
	}
}

exist(obj, key) {
	key in obj
}
