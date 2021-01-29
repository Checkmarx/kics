package Cx

CxPolicy[result] {
	document := input.document[i]
	task := getTasks(document)[t]
	sqs_queue := task["community.aws.sqs_queue"]

	object.get(sqs_queue, "kms_master_key_id", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.sqs_queue}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'kms_master_key_id' is defined",
		"keyActualValue": "'kms_master_key_id' is undefined",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}
