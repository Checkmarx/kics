package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.aws_config_aggregator", "aws_config_aggregator"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudwatchlogs := task[modules[m]]
	ansLib.checkState(cloudwatchlogs)

	not ansLib.isAnsibleTrue(cloudwatchlogs.account_sources.all_aws_regions)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.account_sources.all_aws_regions", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_config_aggregator.account_sources' should have all_aws_regions set to true",
		"keyActualValue": "'aws_config_aggregator.account_sources' has all_aws_regions set to false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudwatchlogs := task[modules[m]]
	ansLib.checkState(cloudwatchlogs)

	not ansLib.isAnsibleTrue(cloudwatchlogs.organization_source.all_aws_regions)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.organization_source.all_aws_regions", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_config_aggregator.organization_source' should have all_aws_regions set to true",
		"keyActualValue": "'aws_config_aggregator.organization_source' has all_aws_regions set to false",
	}
}
