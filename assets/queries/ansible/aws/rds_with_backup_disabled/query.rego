package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.rds_instance", "rds_instance"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	not common_lib.valid_key(instance, "backup_retention_period")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "rds_instance should have the property 'backup_retention_period' greater than 0",
		"keyActualValue": "rds_instance has the property 'backup_retention_period' unassigned",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	instance.backup_retention_period == 0

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.backup_retention_period", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "rds_instance should have the property 'backup_retention_period' greater than 0",
		"keyActualValue": "rds_instance has the property 'backup_retention_period' assigned to 0",
	}
}
