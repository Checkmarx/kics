package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.cloudtrail", "cloudtrail"}
	cloudtrail := task[modules[m]]

	ansLib.checkState(cloudtrail)
	properties := {"cloudwatch_logs_role_arn", "cloudwatch_logs_log_group_arn"}
	not common_lib.valid_key(cloudtrail, properties[p])

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.%s should be defined", [task.name, modules[m], properties[p]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.%s is not defined", [task.name, modules[m], properties[p]]),
	}
}
