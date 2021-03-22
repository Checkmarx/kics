package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"amazon.aws.cloudformation", "cloudformation"}
	cloudformation := task[modules[m]]
	ansLib.checkState(cloudformation)

	object.get(cloudformation, "stack_policy", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudformation.stack_policy is set",
		"keyActualValue": "cloudformation.stack_policy is undefined",
	}
}
