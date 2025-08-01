package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.ecs_service", "ecs_service"}
	ecs_service := task[modules[m]]
	ansLib.checkState(ecs_service)

    ecs_service.network_configuration.assign_public_ip

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.network_configuration.assign_public_ip", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.network_configuration.assign_public_ip' should be set to false (default value is false)", [modules[m]]),
		"keyActualValue": sprintf("'%s.network_configuration.assign_public_ip' is set to true", [modules[m]]),
	}
}