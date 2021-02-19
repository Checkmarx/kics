package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.iam_managed_policy"].publicly_accessible)
	awsApiGateway := task["community.aws.iam_managed_policy"]
	contains(awsApiGateway.state, "present")
	resource := awsApiGateway.policy.Statement[_].Resource
	contains(resource, "*")
	action := awsApiGateway.policy.Statement[_].Action[j]
	contains(action, "*")
	clusterName := task.name
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.policy.Statement.Action", [clusterName]),
		"issueType": "MissingValue",
		"keyExpectedValue": "community.aws.iam_managed_policy.policy.Statement.Action not contains '*'",
		"keyActualValue": "community.aws.iam_managed_policy.policy.Statement.Action contains '*'",
	}
}
