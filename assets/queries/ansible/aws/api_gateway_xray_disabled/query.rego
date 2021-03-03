package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	tracing := task["community.aws.aws_api_gateway"]

	object.get(tracing, "tracing_enabled", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.aws_api_gateway}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.aws_api_gateway}}.tracing_enabled is defined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.aws_api_gateway}}.tracing_enabled is undefined", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	tracing := task["community.aws.aws_api_gateway"]
	tracingValue := tracing.tracing_enabled

	not ansLib.isAnsibleTrue(tracingValue)

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.aws_api_gateway}}.tracing_enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.aws_api_gateway}}.tracing_enabled is true", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.aws_api_gateway}}.tracing_enabled is false", [task.name]),
	}
}
