package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.efs", "efs"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	efs := task[modules[m]]

	ansLib.checkState(efs)
	not common_lib.valid_key(efs, "tags")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.tags should be set", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.tags is not defined", [task.name, modules[m]]),
	}
}
