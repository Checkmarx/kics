package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
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

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
