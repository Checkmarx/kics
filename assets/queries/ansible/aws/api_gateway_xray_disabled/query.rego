package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	tracing := task["community.aws.aws_api_gateway"]

	object.get(tracing, "tracing_enabled", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.aws_api_gateway}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.aws_api_gateway}}.tracing_enabled is defined", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.aws_api_gateway}}.tracing_enabled is undefined", [task.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	tracing := task["community.aws.aws_api_gateway"]
	tracingValue := tracing.tracing_enabled

	not isTracingEnabled(tracingValue)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.aws_api_gateway}}.tracing_enabled", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.aws_api_gateway}}.tracing_enabled is true", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.aws_api_gateway}}.tracing_enabled is false", [task.name]),
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

isTracingEnabled(value) {
	lower(value) == "yes"
} else {
	lower(value) == "true"
} else {
	value == true
}
