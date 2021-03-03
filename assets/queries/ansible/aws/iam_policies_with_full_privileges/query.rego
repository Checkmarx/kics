package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	ansLib.checkState(awsApiGateway)

	resource := awsApiGateway.policy.Statement[_].Resource
	contains(resource, "*")
	action := awsApiGateway.policy.Statement[_].Action[j]
	contains(action, "*")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.policy.Statement.Action", [task.name]),
		"issueType": "MissingValue",
		"keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Action not contains '*'",
		"keyActualValue": "community.aws.iam_managed_policy.policy.Statement.Action contains '*'",
	}
}
