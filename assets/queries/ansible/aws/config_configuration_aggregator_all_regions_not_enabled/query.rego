package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	cloudwatchlogs := task["community.aws.aws_config_aggregator"]

	not ansLib.isAnsibleTrue(cloudwatchlogs.account_sources.all_aws_regions)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.aws_config_aggregator}}.account_sources.all_aws_regions", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_config_aggregator.account_sources' should have all_aws_regions set to true",
		"keyActualValue": "'aws_config_aggregator.account_sources' has all_aws_regions set to false",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	cloudwatchlogs := task["community.aws.aws_config_aggregator"]

	not ansLib.isAnsibleTrue(cloudwatchlogs.organization_source.all_aws_regions)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.aws_config_aggregator}}.organization_source.all_aws_regions", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_config_aggregator.organization_source' should have all_aws_regions set to true",
		"keyActualValue": "'aws_config_aggregator.organization_source' has all_aws_regions set to false",
	}
}