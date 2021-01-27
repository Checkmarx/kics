package Cx

CxPolicy[result] {
	document := input.document[i]
	tasks := getTasks(document)
	task := tasks[t]
	instance := task["community.aws.rds_instance"]
	not checkEncryption(instance)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.rds_instance}}.storage_encrypted", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_rds_instance.storage_encrypted is true or aws_rds_instance.kms_key_id is defined",
		"keyActualValue": "aws_rds_instance.storage_encrypted is false or undefined",
	}
}

getTasks(document) = result {
	result := [body | playbook := document.playbooks[0]; body := playbook.tasks]
	count(result) != 0
} else = result {
	result := [body | playbook := document.playbooks[_]; body := playbook]
	count(result) != 0
}

checkEncryption(task) {
	task.storage_encrypted == true
}

checkEncryption(task) {
	task.storage_encrypted == false
	task.kms_key_id != ""
}

checkEncryption(task) {
	object.get(task, "storage_encrypted", "undefined") == "undefined"
	task.kms_key_id != ""
}
