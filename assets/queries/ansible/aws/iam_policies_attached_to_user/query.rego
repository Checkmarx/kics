package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	checkState(awsApiGateway)
	lower(awsApiGateway.iam_type) == "user"
	clusterName := task.name
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.iam_type", [clusterName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.iam_managed_policy.iam_type should be configured with group or role",
		"keyActualValue": "community.aws.iam_managed_policy.iam_type is configured with user",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

checkState(awsApiGateway) {
	contains(awsApiGateway.state, "present")
} else {
	object.get(awsApiGateway, "state", "undefined") == "undefined"
}
