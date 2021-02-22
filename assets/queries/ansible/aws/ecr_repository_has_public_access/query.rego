package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	stat := task["community.aws.ecs_ecr"].policy.Statement[j]
	stat.Effect == "Allow"
	stat.Principal == "*"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.ecs_ecr}}.policy.Statement.Principal='*'", [task.name]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "'Statement.Principal' isn't '*'",
		"keyActualValue": "'Statement.Principal' is '*'",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
