package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	instance := task["community.aws.rds_instance"]
	instanceName := task.name

	object.get(instance, "storage_encrypted", "undefined") == "undefined"
	object.get(instance, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.rds_instance}}", [instanceName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.rds_instance.storage_encrypted should be set to true",
		"keyActualValue": "community.aws.rds_instance.storage_encrypted is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	instance := task["community.aws.rds_instance"]
	instanceName := task.name

	not ansLib.isAnsibleTrue(instance.storage_encrypted)
	object.get(instance, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.rds_instance}}.storage_encrypted", [instanceName]),
		"issueType": "WrongValue",
		"keyExpectedValue": "community.aws.rds_instance.storage_encrypted should be set to true",
		"keyActualValue": "community.aws.rds_instance.storage_encrypted is set to false",
	}
}