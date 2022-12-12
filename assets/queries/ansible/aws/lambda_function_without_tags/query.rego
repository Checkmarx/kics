package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.lambda", "lambda"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	lambda := task[modules[m]]

	ansLib.checkState(lambda)
	not common_lib.valid_key(lambda, "tags")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.tags should be defined", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.tags is undefined", [task.name, modules[m]]),
	}
}
