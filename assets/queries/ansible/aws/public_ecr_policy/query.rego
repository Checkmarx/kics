package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	cloudwatchlogs := task["community.aws.ecs_ecr"]
	pol := cloudwatchlogs.policy.Statement[index].Principal
	re_match("\\*", pol)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}.policy", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Principal' is not equal to '*'",
		"keyActualValue": "'policy.Principal' is equal to '*'",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	cloudwatchlogs := task["community.aws.ecs_ecr"]
	pol := cloudwatchlogs.policy
	re_match("\"Principal\"\\ *:\\ *\"\\*\"", pol)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}.policy", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'policy.Principal' is not equal '*'",
		"keyActualValue": "'policy.Principal' is equal '*'",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
