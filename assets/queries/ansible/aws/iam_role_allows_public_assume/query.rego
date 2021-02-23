package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	contains(awsApiGateway.state, "present")
	statement := awsApiGateway.policy.Statement[_]
	resource := statement.Principal[j].AWS
	contains(resource, "*")
	not statement.Effect
	clusterName := task.name
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.Statement.Principal.AWS", [clusterName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS should not contain '*'",
		"keyActualValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS contains '*'",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	contains(awsApiGateway.state, "present")
	statement := awsApiGateway.policy.Statement[_]
	resource := statement.Principal[j].AWS
	contains(resource, "*")
	not contains(statement.Effect, "Deny")
	clusterName := task.name
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.Statement.Principal.AWS", [clusterName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS should not contain '*'",
		"keyActualValue": "community.aws.iam_managed_policy.policy.Statement.Principal.AWS contains '*'",
	}
}