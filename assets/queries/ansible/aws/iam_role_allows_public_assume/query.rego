package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
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
	tasks := getTasks(document)
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

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
