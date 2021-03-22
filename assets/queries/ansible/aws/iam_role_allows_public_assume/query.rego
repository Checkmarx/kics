package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.iam_managed_policy", "iam_managed_policy"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	awsApiGateway := task[modules[m]]
	ansLib.checkState(awsApiGateway)

	statement := awsApiGateway.policy.Statement[_]
	resource := statement.Principal[j].AWS
	contains(resource, "*")
	not statement.Effect

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.Statement.Principal.AWS", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "iam_managed_policy.policy.Statement.Principal.AWS should not contain '*'",
		"keyActualValue": "iam_managed_policy.policy.Statement.Principal.AWS contains '*'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	awsApiGateway := task[modules[m]]
	ansLib.checkState(awsApiGateway)

	statement := awsApiGateway.policy.Statement[_]
	resource := statement.Principal[j].AWS
	contains(resource, "*")
	not contains(statement.Effect, "Deny")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.Statement.Principal.AWS", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "iam_managed_policy.policy.Statement.Principal.AWS should not contain '*'",
		"keyActualValue": "iam_managed_policy.policy.Statement.Principal.AWS contains '*'",
	}
}
