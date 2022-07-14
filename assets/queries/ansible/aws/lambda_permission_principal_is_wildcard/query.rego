package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.lambda_policy", "lambda_policy"}
	lambda := task[modules[m]]

	contains(lambda.principal, "*")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.principal", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.principal shouldn't contain a wildcard", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.principal contains a wildcard", [task.name, modules[m]]),
	}
}
