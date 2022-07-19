package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.lambda", "lambda"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	lambda := task[modules[m]]
	ansLib.checkState(lambda)

	not common_lib.valid_key(lambda, "tracing_mode")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "lambda.tracing_mode should be set",
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.tracing_mode", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "lambda.tracing_mode should be set to 'Active'",
		"keyActualValue": "lambda.tracing_mode is not set to 'Active'",
	}
}
