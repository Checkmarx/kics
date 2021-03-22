package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.aws_api_gateway", "aws_api_gateway"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	tracing := task[modules[m]]
	ansLib.checkState(tracing)

	object.get(tracing, "tracing_enabled", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_api_gateway.tracing_enabled is defined",
		"keyActualValue": "aws_api_gateway.tracing_enabled is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	tracing := task[modules[m]]
	ansLib.checkState(tracing)

	not ansLib.isAnsibleTrue(tracing.tracing_enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.tracing_enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_api_gateway.tracing_enabled is true",
		"keyActualValue": "aws_api_gateway.tracing_enabled is false",
	}
}
