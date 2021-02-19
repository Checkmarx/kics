package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.rds_instance"].publicly_accessible)
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
