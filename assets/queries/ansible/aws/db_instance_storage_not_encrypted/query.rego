package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	instance := task["community.aws.rds_instance"]
	instanceName := task.name

	object.get(instance, "storage_encrypted", "undefined") == "undefined"
	object.get(instance, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.rds_instance}}", [instanceName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.rds_instance.storage_encrypted is defined",
		"keyActualValue": "community.aws.rds_instance.storage_encrypted is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	instance := task["community.aws.rds_instance"]
	instanceName := task.name

	not isAnsibleTrue(instance.storage_encrypted)
	object.get(instance, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.rds_instance}}.storage_encrypted", [instanceName]),
		"issueType": "WrongValue",
		"keyExpectedValue": "community.aws.rds_instance.storage_encrypted is set to true",
		"keyActualValue": "community.aws.rds_instance.storage_encrypted is set to false",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

isAnsibleTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}
