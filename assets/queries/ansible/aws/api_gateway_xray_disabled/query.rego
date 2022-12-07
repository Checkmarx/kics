package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.aws_api_gateway", "aws_api_gateway"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	tracing := task[modules[m]]
	ansLib.checkState(tracing)

	not common_lib.valid_key(tracing, "tracing_enabled")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_api_gateway.tracing_enabled should be defined",
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.tracing_enabled", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_api_gateway.tracing_enabled should be true",
		"keyActualValue": "aws_api_gateway.tracing_enabled is false",
	}
}
