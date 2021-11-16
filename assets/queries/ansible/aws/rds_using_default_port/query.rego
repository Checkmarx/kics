package Cx

import data.generic.ansible as ans_lib
import data.generic.common as common_lib

modules := {"community.aws.rds_instance", "rds_instance"}

CxPolicy[result] {
	task := ans_lib.tasks[id][t]
	instance := task[modules[m]]
	ans_lib.checkState(instance)

	enginePort := common_lib.engines[e]

	instance.engine == e
	instance.port == enginePort

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.port", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'port' is not set to %d", [enginePort]),
		"keyActualValue": sprintf("'port' is set to %d", [enginePort]),
	}
}
