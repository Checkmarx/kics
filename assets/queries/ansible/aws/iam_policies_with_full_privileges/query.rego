package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.iam_managed_policy", "iam_managed_policy"}
	awsApiGateway := task[modules[m]]
	ansLib.checkState(awsApiGateway)

	resource := awsApiGateway.policy.Statement[_].Resource
	contains(resource, "*")
	action := awsApiGateway.policy.Statement[_].Action[j]
	contains(action, "*")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy.Statement.Action", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "iam_managed_policy.policy.Statement.Action not contains '*'",
		"keyActualValue": "iam_managed_policy.policy.Statement.Action contains '*'",
	}
}
