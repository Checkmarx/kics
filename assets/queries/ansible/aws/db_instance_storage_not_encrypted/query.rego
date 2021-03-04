package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["community.aws.rds_instance"]

	object.get(instance, "storage_encrypted", "undefined") == "undefined"
	object.get(instance, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.rds_instance}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.rds_instance.storage_encrypted should be set to true",
		"keyActualValue": "community.aws.rds_instance.storage_encrypted is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["community.aws.rds_instance"]

	not ansLib.isAnsibleTrue(instance.storage_encrypted)
	object.get(instance, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.rds_instance}}.storage_encrypted", [task.name]),
		"issueType": "WrongValue",
		"keyExpectedValue": "community.aws.rds_instance.storage_encrypted should be set to true",
		"keyActualValue": "community.aws.rds_instance.storage_encrypted is set to false",
	}
}
