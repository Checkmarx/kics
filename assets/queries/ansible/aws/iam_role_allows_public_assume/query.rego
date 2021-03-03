package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	ansLib.checkState(awsApiGateway)

	statement := awsApiGateway.policy.Statement[_]
	resource := statement.Principal[j].AWS
	contains(resource, "*")
	not statement.Effect

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.Statement.Principal.AWS", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS should not contain '*'",
		"keyActualValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS contains '*'",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	ansLib.checkState(awsApiGateway)

	statement := awsApiGateway.policy.Statement[_]
	resource := statement.Principal[j].AWS
	contains(resource, "*")
	not contains(statement.Effect, "Deny")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.Statement.Principal.AWS", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS should not contain '*'",
		"keyActualValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS contains '*'",
	}
}
