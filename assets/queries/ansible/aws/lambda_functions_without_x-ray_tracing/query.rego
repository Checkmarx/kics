package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.lambda", "lambda"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	lambda := task[modules[m]]
	ansLib.checkState(lambda)

	object.get(lambda, "tracing_mode", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "lambda.tracing_mode is set",
		"keyActualValue": "lambda.tracing_mode is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	lambda := task[modules[m]]
	ansLib.checkState(lambda)

	lambda.tracing_mode != "Active"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.tracing_mode", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "lambda.tracing_mode is set to 'Active'",
		"keyActualValue": "lambda.tracing_mode is not set to 'Active'",
	}
}
