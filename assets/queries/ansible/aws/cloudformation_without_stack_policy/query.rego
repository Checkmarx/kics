package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task["amazon.aws.cloudformation"], "stack_policy", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{amazon.aws.cloudformation}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "amazon.aws.cloudformation.stack_policy is set",
		"keyActualValue": "amazon.aws.cloudformation.stack_policy is undefined",
	}
}
