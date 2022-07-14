package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.lambda_policy", "lambda_policy"}
	lambda := task[modules[m]]

	ansLib.checkState(lambda)
	lambda.action != "lambda:InvokeFunction"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.action", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.{{%s}}.action should be 'lambda:InvokeFunction'", [task.name, modules[m]]),
		"keyActualValue": sprintf("name={{%s}}.{{%s}}.action is %s", [task.name, modules[m], lambda.action]),
	}
}
