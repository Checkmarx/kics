package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task["community.aws.lambda"], "tracing_mode", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.lambda}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.lambda.tracing_mode is set",
		"keyActualValue": "community.aws.lambda.tracing_mode is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task["community.aws.lambda"].tracing_mode != "Active"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.lambda}}.tracing_mode", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.lambda.tracing_mode is set to 'Active'",
		"keyActualValue": "community.aws.lambda.tracing_mode is not set to 'Active'",
	}
}
