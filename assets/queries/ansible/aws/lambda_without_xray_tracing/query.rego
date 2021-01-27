package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	object.get(task["community.aws.lambda"], "tracing_mode", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.lambda}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.lambda.tracing_mode is set",
		"keyActualValue": "community.aws.lambda.tracing_mode is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	task["community.aws.lambda"].tracing_mode != "Active"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.lambda}}.tracing_mode", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.lambda.tracing_mode is set to 'Active'",
		"keyActualValue": "community.aws.lambda.tracing_mode is not set to 'Active'",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
