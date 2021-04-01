package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.lambda", "lambda"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	lambda := task[modules[m]]

	ansLib.checkState(lambda)
	object.get(lambda, "tags", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.tags is defined", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.tags is undefined", [task.name, modules[m]]),
	}
}
