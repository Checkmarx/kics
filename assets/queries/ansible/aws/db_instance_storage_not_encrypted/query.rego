package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.rds_instance"].publicly_accessible)
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
    ansLib.isAnsibleTrue(task["community.aws.rds_instance"].publicly_accessible)
	instance := task["community.aws.rds_instance"]
	instanceName := task.name

	not isAnsibleTrue(instance.storage_encrypted)
	object.get(instance, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.rds_instance}}.storage_encrypted", [instanceName]),
		"issueType": "WrongValue",
		"keyExpectedValue": "community.aws.rds_instance.storage_encrypted should be set to true",
		"keyActualValue": "community.aws.rds_instance.storage_encrypted is set to false",
	}
}

isAnsibleTrue(answer) {
	lower(answer) == "yes"
} else {
	lower(answer) == "true"
} else {
	answer == true
}
