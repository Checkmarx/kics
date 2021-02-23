package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	object.get(task["amazon.aws.cloudformation"], "notification_arns", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.cloudformation}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "amazon.aws.cloudformation.notification_arns is set",
		"keyActualValue": "amazon.aws.cloudformation.notification_arns is undefined",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
