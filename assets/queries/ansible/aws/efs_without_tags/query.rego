package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.efs", "efs"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	efs := task[modules[m]]

	ansLib.checkState(efs)
	object.get(efs, "tags", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.tags is set", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.tags is not defined", [task.name, modules[m]]),
	}
}
