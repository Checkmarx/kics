package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	isAnsibleFalse(task["community.aws.rds_instance"].auto_minor_version_upgrade)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.rds_instance}}.auto_minor_version_upgrade", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "AWS RDS instance feature auto_minor_version_upgrade should be true",
		"keyActualValue": "AWS RDS instance feature auto_minor_version_upgrade is false",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]

	object.get(task["community.aws.rds_instance"], "auto_minor_version_upgrade", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.rds_instance}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "AWS RDS instance feature auto_minor_version_upgrade should be true",
		"keyActualValue": "AWS RDS instance feature auto_minor_version_upgrade is false",
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
