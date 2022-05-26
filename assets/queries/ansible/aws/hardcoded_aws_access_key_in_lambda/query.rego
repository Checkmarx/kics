package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.lambda", "lambda"}
	lambda := task[modules[m]]
	ansLib.checkState(lambda)

	regex.match(`^[A-Za-z0-9/+=]{40}$`, lambda.aws_access_key)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.aws_access_key", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "lambda.aws_access_key should not be in plaintext",
		"keyActualValue": "lambda.aws_access_key is in plaintext",
	}
}
