package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	ansLib.isAnsibleFalse(task["community.aws.cloudtrail"].enable_logging)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudtrail}}.enable_logging", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudtrail}}.enable_logging is true", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudtrail}}.enable_logging is false", [task.name]),
	}
}
