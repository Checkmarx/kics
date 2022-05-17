package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudwatchlogs_log_group", "cloudwatchlogs_log_group"}
	awsApiGateway := task[modules[m]]
	ansLib.checkState(awsApiGateway)

	not common_lib.valid_key(awsApiGateway, "log_group_name")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudwatchlogs_log_grouptracing_enabled should contain log_group_name",
		"keyActualValue": "cloudwatchlogs_log_group does not contain log_group_name defined",
	}
}
