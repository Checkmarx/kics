package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.rds_instance", "rds_instance"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	not common_lib.valid_key(instance, "storage_encrypted")
	not common_lib.valid_key(instance, "kms_key_id")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
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
	not common_lib.valid_key(instance, "kms_key_id")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.storage_encrypted", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "rds_instance.storage_encrypted should be set to true",
		"keyActualValue": "rds_instance.storage_encrypted is set to false",
	}
}
