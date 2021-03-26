package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudtrail", "cloudtrail"}
	cloudtrail := task[modules[m]]

	ansLib.checkState(cloudtrail)
	properties := {"cloudwatch_logs_role_arn", "cloudwatch_logs_log_group_arn"}
	object.get(cloudtrail, properties[p], "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.%s is defined", [task.name, modules[m], properties[p]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.%s is not defined", [task.name, modules[m], properties[p]]),
	}
}
