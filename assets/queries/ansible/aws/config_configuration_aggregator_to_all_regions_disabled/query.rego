package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.aws_config_aggregator", "aws_config_aggregator"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	cloudwatchlogs := task[modules[m]]
	ansLib.checkState(cloudwatchlogs)
	fields := ["account_sources", "organization_source"]

	not ansLib.isAnsibleTrue(cloudwatchlogs[fields[f]].all_aws_regions)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.%s.all_aws_regions", [task.name, modules[m], fields[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_config_aggregator.%s' should have all_aws_regions set to true", [fields[f]]),
		"keyActualValue": sprintf("'aws_config_aggregator.%s' has all_aws_regions set to false", [fields[f]]),
	}
}
