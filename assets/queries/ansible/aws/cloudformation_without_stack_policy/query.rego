package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["amazon.aws.cloudformation"].publicly_accessible)
	object.get(task["amazon.aws.cloudformation"], "stack_policy", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.cloudformation}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "amazon.aws.cloudformation.stack_policy is set",
		"keyActualValue": "amazon.aws.cloudformation.stack_policy is undefined",
	}
}
