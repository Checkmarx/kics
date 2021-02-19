package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.lambda"].publicly_accessible)
	object.get(task["community.aws.lambda"], "tracing_mode", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.lambda}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.lambda.tracing_mode is set",
		"keyActualValue": "community.aws.lambda.tracing_mode is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.lambda"].publicly_accessible)
	task["community.aws.lambda"].tracing_mode != "Active"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.lambda}}.tracing_mode", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.lambda.tracing_mode is set to 'Active'",
		"keyActualValue": "community.aws.lambda.tracing_mode is not set to 'Active'",
	}
}
