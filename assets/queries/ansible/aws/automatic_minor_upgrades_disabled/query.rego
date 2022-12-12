package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.rds_instance", "rds_instance"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rds_instance := task[modules[m]]
	ansLib.checkState(rds_instance)

	ansLib.isAnsibleFalse(rds_instance.auto_minor_version_upgrade)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.auto_minor_version_upgrade", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "rds_instance.auto_minor_version_upgrade should be true",
		"keyActualValue": "rds_instance.auto_minor_version_upgrade is false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rds_instance := task[modules[m]]
	ansLib.checkState(rds_instance)

	not common_lib.valid_key(rds_instance, "auto_minor_version_upgrade")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "rds_instance.auto_minor_version_upgrade should be set",
		"keyActualValue": "rds_instance.auto_minor_version_upgrade is undefined",
	}
}
