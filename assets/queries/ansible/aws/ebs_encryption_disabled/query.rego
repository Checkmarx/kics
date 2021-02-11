package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	isAnsibleFalse(task["amazon.aws.ec2_vol"].encrypted)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2_vol}}.encrypted", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "AWS EBS encryption is enabled",
		"keyActualValue": "AWS EBS encryption is disabled",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	object.get(task["amazon.aws.ec2_vol"], "encrypted", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{amazon.aws.ec2_vol}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "AWS EBS encryption is defined",
		"keyActualValue": "AWS EBS encryption is undefined",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

isAnsibleFalse(answer) {
	lower(answer) == "no"
} else {
	lower(answer) == "false"
} else {
	answer == false
}
