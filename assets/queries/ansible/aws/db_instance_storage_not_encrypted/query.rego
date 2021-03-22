package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.rds_instance", "rds_instance"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	object.get(instance, "storage_encrypted", "undefined") == "undefined"
	object.get(instance, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "rds_instance.storage_encrypted should be set to true",
		"keyActualValue": "rds_instance.storage_encrypted is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	not ansLib.isAnsibleTrue(instance.storage_encrypted)
	object.get(instance, "kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.storage_encrypted", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "rds_instance.storage_encrypted should be set to true",
		"keyActualValue": "rds_instance.storage_encrypted is set to false",
	}
}
