package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudwatchlogs_log_group", "cloudwatchlogs_log_group"}
	awsApiGateway := task[modules[m]]
	ansLib.checkState(awsApiGateway)

	object.get(awsApiGateway, "log_group_name", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudwatchlogs_log_grouptracing_enabled should contain log_group_name",
		"keyActualValue": "cloudwatchlogs_log_group does not contain log_group_name defined",
	}
}
