package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	lambda := task["community.aws.lambda"]

	regex.match(`^[A-Za-z0-9/+=]{40}$`, lambda.aws_access_key)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.lambda}}.aws_access_key", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}}.{{community.aws.lambda}}.aws_access_key should not be in plaintext", [task.name]),
		"keyActualValue": sprintf("{{%s}}.{{community.aws.lambda}}.aws_access_key is in plaintext", [task.name]),
	}
}
