package Cx

import data.generic.terraform as terraform_lib

validTypes := {"audit"}

validTypeConcat := concat(", ", validTypes)

CxPolicy[result] {
	resource := input.document[i].resource.aws_neptune_cluster[name]
	not exist(resource, "enable_cloudwatch_logs_exports")
	

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_neptune_cluster[{{%s}}]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_neptune_cluster.enable_cloudwatch_logs_exports is defined",
		"keyActualValue": "aws_neptune_cluster.enable_cloudwatch_logs_exports is undefined",
	}
}

CxPolicy[result] {
	logs := input.document[i].resource.aws_neptune_cluster[name].enable_cloudwatch_logs_exports
	terraform_lib.empty_array(logs)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_neptune_cluster[{{%s}}].enable_cloudwatch_logs_exports", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_neptune_cluster.enable_cloudwatch_logs_exports should have all following values: %s", [validTypeConcat]),
		"keyActualValue": "aws_neptune_cluster.enable_cloudwatch_logs_exports is empty",
	}
}

CxPolicy[result] {
	logs := input.document[i].resource.aws_neptune_cluster[name].enable_cloudwatch_logs_exports
	not terraform_lib.empty_array(logs)

	logsSet := {log | log := logs[_]}
	missingTypes := validTypes - logsSet

	count(missingTypes) > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_neptune_cluster[{{%s}}].enable_cloudwatch_logs_exports", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_neptune_cluster.enable_cloudwatch_logs_exports should have all following values: %s", [validTypeConcat]),
		"keyActualValue": sprintf("aws_neptune_cluster.enable_cloudwatch_logs_exports has the following missing values: %s", [concat(", ", missingTypes)]),
	}
}

exist(obj, key) {
	_ = obj[key]
}
