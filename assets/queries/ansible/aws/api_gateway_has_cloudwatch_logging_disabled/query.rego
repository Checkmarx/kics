package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	awsApiGateway := task["community.aws.cloudwatchlogs_log_group"]
	object.get(awsApiGateway, "log_group_name", "undefined") == "undefined"
	clusterName := task.name
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.cloudwatchlogs_log_group}}", [clusterName]),
		"issueType": "MissingValue",
		"keyExpectedValue": "community.aws.cloudwatchlogs_log_grouptracing_enabled should contain log_group_name",
		"keyActualValue": "community.aws.cloudwatchlogs_log_group does not contain log_group_name defined",
	}
}

